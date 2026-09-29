#!/usr/bin/env python3
"""Simple screenshot diff helper for App Factory review.

Usage:
  python image_diff.py ref.png built.png --out output/checks/home_diff.png

This is a review aid, not an automated pixel-perfect acceptance gate.
"""
import argparse
import json
from pathlib import Path

import numpy as np
from PIL import Image, ImageChops, ImageEnhance


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('reference')
    ap.add_argument('built')
    ap.add_argument('--out', required=True)
    ap.add_argument('--report')
    args = ap.parse_args()

    ref = Image.open(args.reference).convert('RGB')
    built = Image.open(args.built).convert('RGB')
    original_built_size = built.size
    if built.size != ref.size:
        built = built.resize(ref.size, Image.Resampling.LANCZOS)

    a = np.asarray(ref).astype(np.int16)
    b = np.asarray(built).astype(np.int16)
    delta = np.abs(a - b)
    mae = float(delta.mean())
    changed = float((delta.max(axis=2) > 20).mean() * 100)

    diff = ImageChops.difference(ref, built)
    diff = ImageEnhance.Contrast(diff).enhance(3.0)
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    diff.save(out)

    report = {
        'reference_size': ref.size,
        'built_size': original_built_size,
        'resized_for_comparison': original_built_size != ref.size,
        'mean_absolute_rgb_delta_0_255': round(mae, 3),
        'pixels_changed_over_20_pct': round(changed, 3),
        'note': 'Review aid only; system font/status-bar differences can be legitimate.',
    }
    report_path = Path(args.report) if args.report else out.with_suffix('.json')
    report_path.write_text(json.dumps(report, indent=2), encoding='utf-8')
    print(json.dumps(report, indent=2))
    print('diff ->', out)
    print('report ->', report_path)


if __name__ == '__main__':
    main()
