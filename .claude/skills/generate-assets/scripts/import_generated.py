#!/usr/bin/env python3
"""Import generated image URLs into Flutter assets.

Input JSON: {"hero_home": "https://...", "app_icon": "https://..."}
`app_icon` is saved as assets/brand/app_icon_1024.png for platform icon generation later.
Other items become assets/images/asset_gen_<name>.webp.
"""
import argparse
import io
import json
import os
import urllib.request
from PIL import Image


def fetch(url):
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 FlutterAppFactory-assets/1.0'})
    return Image.open(io.BytesIO(urllib.request.urlopen(req, timeout=120).read())).convert('RGB')


def safe(value):
    return ''.join(c if c.isalnum() else '_' for c in str(value).lower()).strip('_')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('urls_json')
    ap.add_argument('--out', default='assets/images')
    ap.add_argument('--brand', default='assets/brand')
    ap.add_argument('--manifest', default='output/assets-manifest.md')
    ap.add_argument('--max-side', type=int, default=1920)
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    os.makedirs(a.brand, exist_ok=True)
    os.makedirs(os.path.dirname(a.manifest) or '.', exist_ok=True)
    urls = json.load(open(a.urls_json, encoding='utf-8'))
    rows = []

    for raw_name, url in urls.items():
        name = safe(raw_name)
        try:
            im = fetch(url)
            if name in {'app_icon', 'gen_icon', 'icon'}:
                im = im.resize((1024, 1024), Image.Resampling.LANCZOS)
                dst = os.path.join(a.brand, 'app_icon_1024.png')
                im.save(dst, 'PNG', optimize=True)
            else:
                if max(im.size) > a.max_side:
                    scale = a.max_side / max(im.size)
                    im = im.resize((int(im.width * scale), int(im.height * scale)), Image.Resampling.LANCZOS)
                dst = os.path.join(a.out, f'asset_gen_{name}.webp')
                im.save(dst, 'WEBP', quality=82, method=6)
            rows.append((raw_name, dst, f'{im.width}x{im.height} {os.path.getsize(dst)//1024}KB', url))
            print('ok', raw_name, '->', dst)
        except Exception as exc:
            rows.append((raw_name, '-', f'ERR {exc}', url))
            print('ERR', raw_name, exc)

    with open(a.manifest, 'a', encoding='utf-8') as m:
        m.write('\n## Generated assets imported\n| name | asset | note | source/export |\n|---|---|---|---|\n')
        for name, dst, note, url in rows:
            m.write(f'| {name} | `{dst}` | {note} | {url} |\n')
    print('->', a.manifest)


if __name__ == '__main__':
    main()
