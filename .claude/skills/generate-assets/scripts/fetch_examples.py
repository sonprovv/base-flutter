#!/usr/bin/env python3
"""Download explicitly permitted API example images into Flutter assets/images.

Reads output/api/samples/*_styles.json and fields named `example`.
Do not use this for images scraped from a reference application.
"""
import argparse
import glob
import io
import json
import os
import urllib.request
from PIL import Image

UA = 'Mozilla/5.0 FlutterAppFactory-assets/1.0'


def items(obj):
    out = []
    for it in obj.get('styles', []) + obj.get('colors', []):
        if isinstance(it, dict) and it.get('example'):
            out.append((it.get('id') or 'default', None, it['example']))
    for gk in ('categories', 'buckets'):
        for group in obj.get(gk, []):
            for it in group.get('styles', []):
                if isinstance(it, dict) and it.get('example'):
                    out.append((it.get('id') or 'default', group.get('id'), it['example']))
    if not out and obj.get('example'):
        out.append(('default', None, obj['example']))
    return out


def safe(value):
    return ''.join(c if c.isalnum() else '_' for c in str(value).lower()).strip('_')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--samples', default='output/api/samples')
    ap.add_argument('--out', default='assets/images')
    ap.add_argument('--max-side', type=int, default=1080)
    ap.add_argument('--quality', type=int, default=82)
    ap.add_argument('--only', default='')
    ap.add_argument('--limit', type=int, default=0)
    ap.add_argument('--manifest', default='output/assets-manifest.md')
    a = ap.parse_args()
    only = {x.strip() for x in a.only.split(',') if x.strip()}
    os.makedirs(a.out, exist_ok=True)
    os.makedirs(os.path.dirname(a.manifest) or '.', exist_ok=True)
    rows = []

    for path in sorted(glob.glob(os.path.join(a.samples, '*_styles.json'))):
        feature = os.path.basename(path).replace('_styles.json', '')
        if only and feature not in only:
            continue
        data = json.load(open(path, encoding='utf-8'))
        lst = items(data.get('styles') or data)
        if a.limit:
            lst = lst[:a.limit]
        for sid, category, url in lst:
            suffix = safe((str(category) + '_') if category else '') + safe(sid)
            name = f'asset_{safe(feature)}_{suffix}'
            dst = os.path.join(a.out, name + '.webp')
            if os.path.exists(dst):
                rows.append((dst, url, 'cached'))
                continue
            try:
                req = urllib.request.Request(url, headers={'User-Agent': UA})
                raw = urllib.request.urlopen(req, timeout=60).read()
                im = Image.open(io.BytesIO(raw)).convert('RGB')
                if max(im.size) > a.max_side:
                    scale = a.max_side / max(im.size)
                    im = im.resize((int(im.width * scale), int(im.height * scale)), Image.Resampling.LANCZOS)
                im.save(dst, 'WEBP', quality=a.quality, method=6)
                note = f'{im.width}x{im.height} {os.path.getsize(dst)//1024}KB'
                rows.append((dst, url, note))
                print('ok', dst, note)
            except Exception as exc:
                rows.append((dst, url, f'ERR {exc}'))
                print('ERR', name, exc)

    with open(a.manifest, 'a', encoding='utf-8') as m:
        m.write('\n## Permitted API example images\n| asset | source | note |\n|---|---|---|\n')
        for asset, url, note in rows:
            m.write(f'| `{asset}` | {url} | {note} |\n')
    print('->', a.manifest, len(rows), 'items')


if __name__ == '__main__':
    main()
