#!/usr/bin/env python3
"""Fetch an OpenAPI/Swagger JSON snapshot using only stdlib.

Usage:
  python fetch_openapi.py https://host/openapi.json --out output/api/openapi.json
"""
import argparse
import json
from pathlib import Path
import urllib.request


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('url')
    ap.add_argument('--out', default='output/api/openapi.json')
    ap.add_argument('--header', action='append', default=[], help='Header as Name:Value; avoid putting secrets in shell history.')
    args = ap.parse_args()
    headers = {'User-Agent': 'FlutterAppFactory/1.0', 'Accept': 'application/json'}
    for item in args.header:
        name, value = item.split(':', 1)
        headers[name.strip()] = value.strip()
    req = urllib.request.Request(args.url, headers=headers)
    with urllib.request.urlopen(req, timeout=60) as response:
        raw = response.read()
    data = json.loads(raw.decode('utf-8'))
    path = Path(args.out)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False), encoding='utf-8')
    print('openapi:', data.get('openapi') or data.get('swagger'), 'paths:', len(data.get('paths', {})))
    print('->', path)


if __name__ == '__main__':
    main()
