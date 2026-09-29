#!/usr/bin/env python
"""contact_sheet.py <folder> <out.png> — ghep moi anh trong folder thanh 1 sheet de Read va chon."""
import glob, os, sys
from PIL import Image, ImageDraw

folder, out = sys.argv[1], sys.argv[2]
files = sorted(f for f in glob.glob(os.path.join(folder, "*")) if f.lower().endswith((".webp", ".jpg", ".jpeg", ".png")))
cols, cell = 6, 220
rows = (len(files) + cols - 1) // cols or 1
sheet = Image.new("RGB", (cols * cell, rows * (cell + 24)), (245, 245, 245)); d = ImageDraw.Draw(sheet)
for i, f in enumerate(files):
    try:
        im = Image.open(f).convert("RGB"); im.thumbnail((cell - 8, cell - 8))
    except Exception:
        continue
    x = (i % cols) * cell + 4; y = (i // cols) * (cell + 24) + 4
    sheet.paste(im, (x, y)); d.text((x, y + cell - 6), os.path.basename(f)[:30], fill=(0, 0, 0))
os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
sheet.save(out); print(len(files), "files ->", out)
