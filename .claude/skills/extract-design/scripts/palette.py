#!/usr/bin/env python
"""
palette.py — phan tich pixel screenshot -> palette.json + swatch png.
Chi can Pillow + numpy (khong dung sklearn).

  python palette.py input/screenshots --out output/palette.json --swatch output/palette.png

Ket qua:
  global.dominant     : top mau toan app (quantize 4-bit/kenh, gop mau gan nhau)
  global.backgrounds  : mau nen uoc luong (vung phang + vien anh)
  global.accents      : mau bao hoa cao, it pixel -> ung vien primary/CTA
  global.text         : mau chu uoc luong (tuong phan cao voi nen)
  per_image[]         : dominant/background/accent/gradient_candidates tung anh
"""
import argparse
import colorsys
import json
import os
import sys
from collections import Counter
from datetime import datetime

import numpy as np
from PIL import Image, ImageDraw

TOP_CUT = 0.04     # status bar
BOTTOM_CUT = 0.04  # nav bar
MAX_W = 360        # downscale cho nhanh; 1080 -> 360 (chuan hoa gan 360 logical px ngang)

NAMED = {
    "white": (255, 255, 255), "black": (0, 0, 0), "gray": (128, 128, 128),
    "red": (220, 40, 40), "orange": (255, 140, 0), "yellow": (250, 210, 40),
    "green": (60, 180, 80), "teal": (30, 190, 170), "cyan": (80, 220, 255),
    "blue": (50, 110, 240), "indigo": (90, 80, 220), "purple": (150, 90, 230),
    "pink": (240, 110, 180), "brown": (130, 90, 50), "beige": (235, 220, 200),
}


def hexs(rgb):
    r, g, b = (int(x) for x in rgb)
    return f"#{r:02X}{g:02X}{b:02X}"


def nearest_name(rgb):
    r, g, b = rgb
    h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
    if v < 0.12:
        return "black"
    if s < 0.10:
        return "white" if v > 0.90 else ("light gray" if v > 0.6 else "gray" if v > 0.3 else "dark gray")
    best = min(NAMED.items(), key=lambda kv: sum((a - b) ** 2 for a, b in zip(kv[1], rgb)))
    return best[0]


def luminance(rgb):
    def ch(c):
        c = c / 255
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = rgb
    return 0.2126 * ch(r) + 0.7152 * ch(g) + 0.0722 * ch(b)


def contrast(a, b):
    la, lb = luminance(a), luminance(b)
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)


def load(path):
    im = Image.open(path).convert("RGB")
    w, h = im.size
    im = im.crop((0, int(h * TOP_CUT), w, int(h * (1 - BOTTOM_CUT))))
    if im.width > MAX_W:
        im = im.resize((MAX_W, int(im.height * MAX_W / im.width)), Image.BILINEAR)
    return im, (w, h)


def quantize(arr, bits=4):
    shift = 8 - bits
    q = (arr >> shift) << shift
    q = q + (1 << (shift - 1))  # tam giua bin
    return np.clip(q, 0, 255)


def dominant(arr, top=12):
    q = quantize(arr.reshape(-1, 3))
    keys = q[:, 0].astype(np.int64) * 65536 + q[:, 1].astype(np.int64) * 256 + q[:, 2].astype(np.int64)
    cnt = Counter(keys.tolist())
    total = len(keys)
    out = []
    for k, n in cnt.most_common(top * 3):
        rgb = ((k >> 16) & 255, (k >> 8) & 255, k & 255)
        # gop mau gan (khoang cach < 24) vao mau da co
        merged = False
        for o in out:
            if sum((a - b) ** 2 for a, b in zip(o["_rgb"], rgb)) < 24 ** 2:
                o["pct"] += n / total * 100
                merged = True
                break
        if not merged:
            out.append({"_rgb": rgb, "pct": n / total * 100})
        if len(out) >= top:
            break
    for o in out:
        o["hex"] = hexs(o["_rgb"])
        o["name"] = nearest_name(o["_rgb"])
        h, s, v = colorsys.rgb_to_hsv(*(c / 255 for c in o["_rgb"]))
        o["hsv"] = [round(h * 360), round(s, 2), round(v, 2)]
        o["pct"] = round(o["pct"], 2)
        del o["_rgb"]
    return out


def flat_regions(arr, block=12, tol=6.0):
    """Mau cua cac block phang (std thap) -> ung vien nen / surface."""
    h, w, _ = arr.shape
    cols = []
    for y in range(0, h - block, block):
        for x in range(0, w - block, block):
            b = arr[y:y + block, x:x + block].reshape(-1, 3).astype(np.float32)
            if b.std(axis=0).mean() < tol:
                cols.append(b.mean(axis=0))
    if not cols:
        return []
    return dominant(np.array(cols, dtype=np.uint8).reshape(-1, 1, 3), top=6)


def border_colors(arr):
    h, w, _ = arr.shape
    m = max(2, w // 60)
    edge = np.concatenate([arr[:m].reshape(-1, 3), arr[-m:].reshape(-1, 3),
                           arr[:, :m].reshape(-1, 3), arr[:, -m:].reshape(-1, 3)])
    return dominant(edge.reshape(-1, 1, 3), top=4)


def accents(arr, min_s=0.35, min_v=0.35, top=8, block=6, tol=10.0, edge_dist=80.0, radius=3):
    """Mau bao hoa trong block PHANG, va co block phang KHAC MAU RO o gan (UI element nam tren nen).
    Anh chup blur: phang nhung chuyen muot -> khong co bien sac -> bi loai."""
    h, w, _ = arr.shape
    gh, gw = h // block, w // block
    means = np.zeros((gh, gw, 3), np.float32)
    flat = np.zeros((gh, gw), bool)
    for gy in range(gh):
        for gx in range(gw):
            b = arr[gy * block:(gy + 1) * block, gx * block:(gx + 1) * block].reshape(-1, 3).astype(np.float32)
            means[gy, gx] = b.mean(axis=0)
            flat[gy, gx] = b.std(axis=0).mean() < tol
    cols = []
    for gy in range(gh):
        for gx in range(gw):
            if not flat[gy, gx]:
                continue
            m = means[gy, gx] / 255
            mx, mn = m.max(), m.min()
            sat = (mx - mn) / max(mx, 1e-6)
            if sat < min_s or mx < min_v:
                continue
            y0, y1 = max(0, gy - radius), min(gh, gy + radius + 1)
            x0, x1 = max(0, gx - radius), min(gw, gx + radius + 1)
            nb_flat = flat[y0:y1, x0:x1]
            nb_dist = np.abs(means[y0:y1, x0:x1] - means[gy, gx]).sum(axis=2)
            if (nb_flat & (nb_dist > edge_dist)).any():
                cols.append(means[gy, gx])
    if len(cols) < 3:
        return []
    res = dominant(np.array(cols, dtype=np.uint8).reshape(-1, 1, 3), top=top)
    for r in res:
        r["pct_of_image"] = round(r["pct"] * len(cols) / max(1, gh * gw), 3)
    return res


def text_colors(arr, bg_rgb, top=5):
    """Pixel co contrast >= 4.5 voi nen va it bao hoa -> ung vien mau chu."""
    px = arr.reshape(-1, 3)
    lum = np.apply_along_axis(lambda p: luminance(p), 1, px[::7])  # sample
    bg_l = luminance(bg_rgb)
    ratio = np.where(lum > bg_l, (lum + 0.05) / (bg_l + 0.05), (bg_l + 0.05) / (lum + 0.05))
    sub = px[::7].astype(np.float32) / 255
    sat = np.where(sub.max(axis=1) > 0, (sub.max(axis=1) - sub.min(axis=1)) / np.maximum(sub.max(axis=1), 1e-6), 0)
    cand = px[::7][(ratio >= 4.5) & (sat < 0.35)]
    if len(cand) < 20:
        return []
    return dominant(cand.reshape(-1, 1, 3), top=top)


def gradient_candidates(arr, min_len_frac=0.28, hard_edge=25.0):
    """Tim hang co mau chuyen deu (gradient ngang) -> ung vien CTA gradient.
    Cat hang tai bien cung (d > hard_edge), moi doan du dai + muot trung binh + 2 dau khac mau -> gradient."""
    h, w, _ = arr.shape
    found = []
    for y in range(0, h, max(1, h // 250)):
        row = arr[y].astype(np.float32)
        d = np.abs(np.diff(row, axis=0)).sum(axis=1)
        cuts = [0] + [i + 1 for i in np.where(d > hard_edge)[0]] + [w]
        for a, b in zip(cuts[:-1], cuts[1:]):
            if b - a < w * min_len_frac:
                continue
            seg_d = d[a:b - 1]
            if seg_d.mean() > 6 or np.abs(np.diff(seg_d)).mean() > 4:
                continue
            c0, c1 = row[a + 2], row[b - 3]
            if np.abs(c0 - c1).sum() < 50:
                continue
            found.append({"y_pct": round(y / h * 100, 1), "from": hexs(c0), "to": hexs(c1),
                          "mid": hexs((c0 + c1) / 2), "x_pct": [round(a / w * 100), round(b / w * 100)]})
    merged = []
    for f in found:
        if merged:
            m = merged[-1]
            close_y = abs(m.get("y_pct_end", m["y_pct"]) - f["y_pct"]) < 2.5
            same_from = sum(abs(int(m["from"][i:i+2], 16) - int(f["from"][i:i+2], 16)) for i in (1, 3, 5)) < 60
            if close_y and same_from:
                m["y_pct_end"] = f["y_pct"]
                m["rows"] = m.get("rows", 1) + 1
                continue
        merged.append(dict(f, rows=1))
    merged = [m for m in merged if m["rows"] >= 4]
    merged.sort(key=lambda m: -m["rows"])
    return merged[:6]


def analyze(path):
    im, orig = load(path)
    arr = np.asarray(im)
    bg = border_colors(arr)
    flat = flat_regions(arr)
    bg_guess = (flat[0] if flat else bg[0]) if (flat or bg) else {"hex": "#FFFFFF"}
    bg_rgb = tuple(int(bg_guess["hex"][i:i + 2], 16) for i in (1, 3, 5))
    return {
        "file": os.path.basename(path),
        "resolution": f"{orig[0]}x{orig[1]}",
        "dominant": dominant(arr, top=8),
        "background_guess": bg_guess["hex"],
        "border": bg,
        "flat_regions": flat,
        "accents": accents(arr),
        "text": text_colors(arr, bg_rgb),
        "gradient_candidates": gradient_candidates(arr),
        "is_dark": luminance(bg_rgb) < 0.2,
    }


def merge(per):
    def skin_like(hx):
        rgb = tuple(int(hx[i:i + 2], 16) / 255 for i in (1, 3, 5))
        hh, ss, vv = colorsys.rgb_to_hsv(*rgb)
        return 10 <= hh * 360 <= 50 and ss < 0.65

    def agg(key, top=10, weight="pct", drop_skin=False):
        c = Counter()
        for p in per:
            for e in p[key]:
                if drop_skin and skin_like(e["hex"]):
                    continue
                c[e["hex"]] += e.get(weight, 1)
        out = []
        for hx, v in c.most_common(top):
            rgb = tuple(int(hx[i:i + 2], 16) for i in (1, 3, 5))
            out.append({"hex": hx, "score": round(v, 2), "name": nearest_name(rgb)})
        return out
    bgs = Counter(p["background_guess"] for p in per)
    return {
        "dominant": agg("dominant"),
        "backgrounds": [{"hex": h, "images": n, "name": nearest_name(tuple(int(h[i:i+2], 16) for i in (1, 3, 5)))} for h, n in bgs.most_common(5)],
        "accents": agg("accents", weight="pct_of_image", drop_skin=True),
        "gradients": [dict(g, file=p["file"]) for p in per for g in p["gradient_candidates"][:2]],
        "text": agg("text", top=6),
        "dark_images": sum(1 for p in per if p["is_dark"]),
        "light_images": sum(1 for p in per if not p["is_dark"]),
    }


def swatch(glob, per, out):
    rows = [("dominant", glob["dominant"]), ("backgrounds", glob["backgrounds"]),
            ("accents", glob["accents"]), ("text", glob["text"])]
    cell, pad = 90, 8
    W = 130 + 10 * (cell + pad)
    H = (len(rows) + len(per)) * (cell + pad) + 30
    img = Image.new("RGB", (W, H), (245, 245, 245))
    d = ImageDraw.Draw(img)
    y = 10
    for label, items in rows:
        d.text((8, y + 30), label, fill=(0, 0, 0))
        for i, it in enumerate(items[:10]):
            x = 130 + i * (cell + pad)
            rgb = tuple(int(it["hex"][k:k + 2], 16) for k in (1, 3, 5))
            d.rectangle([x, y, x + cell, y + cell - 22], fill=rgb, outline=(0, 0, 0))
            d.text((x + 2, y + cell - 20), it["hex"], fill=(0, 0, 0))
        y += cell + pad
    for p in per:
        d.text((8, y + 30), p["file"][:16], fill=(0, 0, 0))
        items = p["dominant"][:5] + p["accents"][:5]
        for i, it in enumerate(items[:10]):
            x = 130 + i * (cell + pad)
            rgb = tuple(int(it["hex"][k:k + 2], 16) for k in (1, 3, 5))
            d.rectangle([x, y, x + cell, y + cell - 22], fill=rgb, outline=(0, 0, 0))
            d.text((x + 2, y + cell - 20), it["hex"], fill=(0, 0, 0))
        y += cell + pad
    img.save(out)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("folder")
    ap.add_argument("--out", default="output/palette.json")
    ap.add_argument("--swatch", default=None)
    a = ap.parse_args()
    files = sorted(f for f in os.listdir(a.folder) if f.lower().endswith((".png", ".jpg", ".jpeg", ".webp")))
    if not files:
        print("No screenshots in", a.folder, file=sys.stderr)
        sys.exit(1)
    per = [analyze(os.path.join(a.folder, f)) for f in files]
    glob = merge(per)
    res = {"generated_at": datetime.now().isoformat(timespec="seconds"), "count": len(per),
           "global": glob, "per_image": per}
    os.makedirs(os.path.dirname(a.out) or ".", exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as f:
        json.dump(res, f, indent=2, ensure_ascii=False)
    if a.swatch:
        swatch(glob, per, a.swatch)
    # tom tat ra stdout
    print(f"{len(per)} images | dark={glob['dark_images']} light={glob['light_images']}")
    print("backgrounds:", ", ".join(f"{b['hex']}({b['images']})" for b in glob["backgrounds"]))
    print("accents    :", ", ".join(f"{x['hex']} {x['name']}" for x in glob["accents"][:6]))
    print("text       :", ", ".join(x["hex"] for x in glob["text"][:4]))
    for p in per:
        print(f"  {p['file']:<22} bg={p['background_guess']} acc=" + ", ".join(f"{a['hex']}" for a in p["accents"][:4]))
        g = p["gradient_candidates"]
        if g:
            print(f"gradient {p['file']}: " + "; ".join(f"{x['from']}->{x['to']} @y{x['y_pct']}%" for x in g[:3]))
    print("->", a.out)


if __name__ == "__main__":
    main()
