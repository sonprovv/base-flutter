#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Parse team Master Plan xlsx for Flutter monetization.

Outputs:
  output/monetization/app_config.json
  output/monetization/ad_config.json
  output/monetization/ad_script.md

Supported ad-id columns (case-insensitive):
- Android Ad Unit ID / Android ID
- iOS Ad Unit ID / iOS ID
- Ad Unit ID (legacy): treated as Android only; iOS remains blank.

Remote Config Key is used as placement key. `<name>_2f` is folded into the
same placement using android_id_2f / ios_id_2f.
"""
import argparse
import io
import json
import os
import re
import sys

import openpyxl

try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass


def norm(value):
    return (str(value) if value is not None else '').replace('\n', ' / ').strip()


def first_after(cells, index):
    return next((v for v in cells[index + 1:] if v), '')


def parse_cover(ws):
    cfg = {}
    if ws is None:
        return cfg
    for row in ws.iter_rows(values_only=True):
        cells = [norm(c) for c in row]
        for i, cell in enumerate(cells):
            if not cell:
                continue
            key = cell.lower()
            val = first_after(cells, i)
            if key.startswith('product id'):
                cfg['product_id'] = val
            elif key.startswith('name on phone') or key.startswith('app name'):
                cfg['app_name'] = val
            elif key.startswith('package name') or key.startswith('android package'):
                cfg['android_application_id'] = val.rstrip(' /')
            elif key.startswith('ios bundle') or key.startswith('bundle id'):
                cfg['ios_bundle_id'] = val.rstrip(' /')
            elif key.startswith('tiktok app id'):
                cfg['tiktok_app_id'] = val
            elif key.startswith('appsflyer'):
                cfg['appsflyer_key'] = val
            elif key.startswith('adjust app token'):
                cfg['adjust_app_token'] = val
            elif key.startswith('adjust revenue'):
                cfg['adjust_revenue_token'] = val
            elif key.startswith('facebook app id'):
                cfg['facebook_app_id'] = val
            elif key.startswith('facebook app token') or key.startswith('facebook client token'):
                cfg['facebook_client_token'] = val
            elif key.startswith('privacy policy'):
                cfg['privacy_policy_url'] = val
            elif key.startswith('app-ads'):
                cfg['app_ads_txt'] = val
            elif key.startswith('firebase'):
                cfg['firebase'] = val
            break
    return cfg


def header_map(cells):
    return {c.lower().strip(): i for i, c in enumerate(cells) if c.strip()}


def pick(cells, headers, *names):
    for name in names:
        idx = headers.get(name.lower())
        if idx is not None and idx < len(cells):
            return cells[idx]
    return ''


def parse_iaa(ws):
    app_ids = {'android': '', 'ios': ''}
    rows = []
    headers = None
    for raw in ws.iter_rows(values_only=True):
        cells = [norm(c) for c in raw]
        joined = ' '.join(cells).lower()

        if 'admob app id' in joined:
            ids = [c for c in cells if c.startswith('ca-app-pub')]
            if ids:
                # If two IDs exist, preserve order and let report flag ambiguity.
                if not app_ids['android']:
                    app_ids['android'] = ids[0]
                elif not app_ids['ios']:
                    app_ids['ios'] = ids[0]
            # Continue because some sheets put labels/ids elsewhere on same row.

        candidate = header_map(cells)
        if 'ad type' in candidate and ('ad unit name' in candidate or 'placement' in candidate):
            headers = candidate
            continue
        if headers is None:
            continue

        name = pick(cells, headers, 'ad unit name', 'placement', 'name')
        if not name:
            continue
        legacy_id = pick(cells, headers, 'ad unit id', 'unit id')
        android_id = pick(cells, headers, 'android ad unit id', 'android id') or legacy_id
        ios_id = pick(cells, headers, 'ios ad unit id', 'ios id')
        rows.append({
            'no': pick(cells, headers, '#', 'no', 'stt'),
            'type': pick(cells, headers, 'ad type', 'format'),
            'name': name,
            'android_id': android_id,
            'ios_id': ios_id,
            'desc': pick(cells, headers, 'ad unit description', 'description', 'position'),
            'rc_key': pick(cells, headers, 'remote config key', 'rc key'),
        })
    return app_ids, rows


def build_config(rows):
    canonical_key = {}
    for row in rows:
        if not row['name'].endswith('_2f'):
            canonical_key[row['name']] = row['rc_key'] or row['name']
    cfg = {}
    for row in rows:
        base_name = re.sub(r'_2f$', '', row['name'])
        key = canonical_key.get(base_name) or row['rc_key'] or base_name
        row['key'] = key
        entry = cfg.setdefault(key, {
            'enabled': True,
            'android_id': '',
            'android_id_2f': '',
            'ios_id': '',
            'ios_id_2f': '',
        })
        second = row['name'].endswith('_2f')
        entry['android_id_2f' if second else 'android_id'] = row['android_id']
        entry['ios_id_2f' if second else 'ios_id'] = row['ios_id']
    for entry in cfg.values():
        if not any(entry[k] for k in ('android_id', 'android_id_2f', 'ios_id', 'ios_id_2f')):
            entry['enabled'] = False
    return cfg


def dart_placement_values(path):
    if not os.path.exists(path):
        return set()
    source = io.open(path, encoding='utf-8').read()
    # static const interHome = 'inter_home'; or "..."
    return set(re.findall(r"static\s+const\s+\w+\s*=\s*['\"]([a-z0-9_]+)['\"]", source))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('xlsx')
    ap.add_argument('--out', default='output/monetization')
    ap.add_argument('--placements', default='lib/core/ads/ad_placements.dart')
    args = ap.parse_args()

    wb = openpyxl.load_workbook(args.xlsx, data_only=True)
    cover = next((s for s in wb.worksheets if s.title.strip().lower() == 'cover'), None)
    iaa = next((s for s in wb.worksheets if s.title.strip().lower().startswith('iaa')), None)
    if iaa is None:
        raise SystemExit("Không tìm thấy sheet bắt đầu bằng 'IAA'")

    os.makedirs(args.out, exist_ok=True)
    app_cfg = parse_cover(cover)
    app_ids, rows = parse_iaa(iaa)
    app_cfg['admob_app_id_android'] = app_ids['android']
    app_cfg['admob_app_id_ios'] = app_ids['ios']
    app_cfg['source'] = os.path.basename(args.xlsx)

    ad_cfg = build_config(rows)
    with open(os.path.join(args.out, 'app_config.json'), 'w', encoding='utf-8') as f:
        json.dump(app_cfg, f, indent=2, ensure_ascii=False)
    with open(os.path.join(args.out, 'ad_config.json'), 'w', encoding='utf-8') as f:
        json.dump(ad_cfg, f, indent=2, ensure_ascii=False)

    md = os.path.join(args.out, 'ad_script.md')
    with open(md, 'w', encoding='utf-8') as f:
        f.write(f"# Ad script — {app_cfg.get('product_id', '')}\n\n")
        f.write(f"Source: `{os.path.basename(args.xlsx)}` / `{iaa.title}`\n\n")
        f.write('| # | format | placement | Android ID | iOS ID | description | RC key |\n')
        f.write('|---|---|---|---|---|---|---|\n')
        for r in rows:
            f.write(f"| {r['no']} | {r['type']} | `{r['name']}` | {r['android_id'] or '-'} | {r['ios_id'] or '-'} | {r['desc'][:160]} | `{r['rc_key']}` |\n")
        f.write('\n## Folded config\n\n')
        f.write('| key | Android | Android 2F | iOS | iOS 2F | enabled |\n')
        f.write('|---|---|---|---|---|---|\n')
        for key, e in ad_cfg.items():
            f.write(f"| `{key}` | {e['android_id'] or '-'} | {e['android_id_2f'] or '-'} | {e['ios_id'] or '-'} | {e['ios_id_2f'] or '-'} | {e['enabled']} |\n")

    code = dart_placement_values(args.placements)
    sheet = set(ad_cfg)
    missing_in_code = sorted(sheet - code)
    missing_in_sheet = sorted(code - sheet)
    missing_ios = sorted(k for k, v in ad_cfg.items() if v['enabled'] and not (v['ios_id'] or v['ios_id_2f']))

    print(f'placements: {len(rows)} rows -> {len(ad_cfg)} keys')
    print('in sheet, NOT in ad_placements.dart:', missing_in_code or 'none')
    print('in ad_placements.dart, NOT in sheet:', missing_in_sheet or 'none')
    print('enabled placements missing iOS id:', missing_ios or 'none')
    print('->', args.out)


if __name__ == '__main__':
    main()
