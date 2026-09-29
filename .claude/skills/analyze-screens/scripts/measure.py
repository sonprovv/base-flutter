#!/usr/bin/env python
"""
measure.py — ve luoi do len screenshot de AI doc toa do chinh xac (Flutter logical px) khi viet screens.json / spec.

  python measure.py input/screenshots/05_home.jpg --grid            # -> output/measure/05_home_grid.png
  python measure.py input/screenshots/05_home.jpg --crop 0 30 100 70 # cat theo % (x0 y0 x1 y1) va ve luoi chi tiet hon
  python measure.py input/screenshots/05_home.jpg --boxes            # tim cac khoi phang lon (card/nut) -> in box_lp

Quy uoc: 360 logical px ngang. lp = px / (W/360).
"""
import argparse
import os

import numpy as np
from PIL import Image, ImageDraw


def draw_grid(im, step_pct=5, label_lp=True):
    w, h = im.size
    scale = w / 360.0
    d = ImageDraw.Draw(im)
    for p in range(0, 101, step_pct):
        x = int(w * p / 100)
        y = int(h * p / 100)
        major = p % 10 == 0
        col = (255, 0, 0, 200) if major else (255, 120, 120, 120)
        d.line([(x, 0), (x, h)], fill=col, width=2 if major else 1)
        d.line([(0, y), (w, y)], fill=col, width=2 if major else 1)
        if major and label_lp:
            d.text((x + 3, 3), f"{p}%|{int(x / scale)}lp", fill=(255, 0, 0))
            d.text((3, y + 3), f"{p}%|{int(y / scale)}lp", fill=(255, 0, 0))
    return im


def find_boxes(im, min_area_lp=1600, tol=8.0, block=6):
    """Khoi phang lien thong (nut, card nen phang). Tra ve list (x,y,w,h) Flutter logical px."""
    arr = np.asarray(im.convert("RGB")).astype(np.float32)
    h, w, _ = arr.shape
    scale = w / 360.0
    gh, gw = h // block, w // block
    flat = np.zeros((gh, gw), bool)
    col = np.zeros((gh, gw, 3), np.float32)
    for gy in range(gh):
        for gx in range(gw):
            b = arr[gy * block:(gy + 1) * block, gx * block:(gx + 1) * block].reshape(-1, 3)
            flat[gy, gx] = b.std(axis=0).mean() < tol
            col[gy, gx] = b.mean(axis=0)
    seen = np.zeros_like(flat)
    boxes = []
    for gy in range(gh):
        for gx in range(gw):
            if not flat[gy, gx] or seen[gy, gx]:
                continue
            stack = [(gy, gx)]
            seen[gy, gx] = True
            cells = []
            base = col[gy, gx]
            while stack:
                cy, cx = stack.pop()
                cells.append((cy, cx))
                for ny, nx in ((cy + 1, cx), (cy - 1, cx), (cy, cx + 1), (cy, cx - 1)):
                    if 0 <= ny < gh and 0 <= nx < gw and flat[ny, nx] and not seen[ny, nx] \
                            and np.abs(col[ny, nx] - base).sum() < 40:
                        seen[ny, nx] = True
                        stack.append((ny, nx))
            ys = [c[0] for c in cells]; xs = [c[1] for c in cells]
            bw = (max(xs) - min(xs) + 1) * block; bh = (max(ys) - min(ys) + 1) * block
            if (bw / scale) * (bh / scale) >= min_area_lp and len(cells) * block * block > 0.6 * bw * bh:
                r, g, b = (int(v) for v in base)
                boxes.append((min(xs) * block, min(ys) * block, bw, bh, f"#{r:02X}{g:02X}{b:02X}"))
    boxes.sort(key=lambda b: (b[1], b[0]))
    return boxes, scale


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("image")
    ap.add_argument("--grid", action="store_true")
    ap.add_argument("--boxes", action="store_true")
    ap.add_argument("--crop", nargs=4, type=float, metavar=("X0", "Y0", "X1", "Y1"), help="% cua anh")
    ap.add_argument("--out", default="output/measure")
    a = ap.parse_args()
    im = Image.open(a.image).convert("RGB")
    W, H = im.size
    name = os.path.splitext(os.path.basename(a.image))[0]
    os.makedirs(a.out, exist_ok=True)
    print(f"{a.image}: {W}x{H}px, scale {W/360:.2f} px/lp, height {H/(W/360):.0f}lp")

    if a.crop:
        x0, y0, x1, y1 = (int(W * a.crop[0] / 100), int(H * a.crop[1] / 100), int(W * a.crop[2] / 100), int(H * a.crop[3] / 100))
        im = im.crop((x0, y0, x1, y1))
        print(f"crop px ({x0},{y0})-({x1},{y1}) = lp ({x0/(W/360):.0f},{y0/(W/360):.0f})-({x1/(W/360):.0f},{y1/(W/360):.0f})")
    if a.boxes:
        boxes, scale = find_boxes(im)
        d = ImageDraw.Draw(im)
        for i, (x, y, w, h, hx) in enumerate(boxes[:60]):
            d.rectangle([x, y, x + w, y + h], outline=(0, 200, 0), width=3)
            d.text((x + 4, y + 4), str(i), fill=(0, 200, 0))
            print(f"box {i:2d}: lp x={x/scale:.0f} y={y/scale:.0f} w={w/scale:.0f} h={h/scale:.0f}  color {hx}")
    if a.grid or not a.boxes:
        im = draw_grid(im, step_pct=5 if not a.crop else 10)
    out = os.path.join(a.out, f"{name}_{'crop_' if a.crop else ''}{'boxes' if a.boxes else 'grid'}.png")
    im.save(out)
    print("->", out)


if __name__ == "__main__":
    main()
