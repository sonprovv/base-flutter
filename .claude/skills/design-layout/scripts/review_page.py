#!/usr/bin/env python
"""
review_page.py — gom output/review/*.png thanh 1 trang HTML: anh goc (_ref) | anh dung, de user xem khong can ngoi canh may.
Anh nhung base64 (tu chua, mo o dau cung duoc). Resize ve 540px ngang de nhe.

  python review_page.py [--dir output/review] [--out output/review/index.html]
"""
import argparse
import base64
import glob
import io
import os
from datetime import datetime

from PIL import Image


def b64(path, width=540):
    im = Image.open(path).convert("RGB")
    if im.width > width:
        im = im.resize((width, int(im.height * width / im.width)), Image.LANCZOS)
    buf = io.BytesIO()
    im.save(buf, "JPEG", quality=82)
    return "data:image/jpeg;base64," + base64.b64encode(buf.getvalue()).decode()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", default="output/review")
    ap.add_argument("--out", default="output/review/index.html")
    ap.add_argument("--title", default="App Factory review")
    a = ap.parse_args()
    files = sorted(glob.glob(os.path.join(a.dir, "*.png")))
    built = [f for f in files if not f.endswith("_ref.png")]
    cards = []
    for f in built:
        name = os.path.splitext(os.path.basename(f))[0]
        ref = os.path.join(a.dir, f"{name}_ref.png")
        ref_img = f'<figure><img src="{b64(ref)}" alt="ref"><figcaption>App tham khảo</figcaption></figure>' if os.path.exists(ref) else ""
        cards.append(f"""
<section>
  <h2>{name}</h2>
  <div class="pair">{ref_img}<figure><img src="{b64(f)}" alt="built"><figcaption>Bản dựng</figcaption></figure></div>
</section>""")
    html = f"""<!DOCTYPE html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>{a.title}</title>
<style>
:root{{--bg:#f6f7fb;--fg:#16201f;--card:#fff;--muted:#5b6470}}
@media (prefers-color-scheme:dark){{:root:not([data-theme=light]){{--bg:#111418;--fg:#e8ebf0;--card:#1b2026;--muted:#9aa4b2}}}}
:root[data-theme=dark]{{--bg:#111418;--fg:#e8ebf0;--card:#1b2026;--muted:#9aa4b2}}
body{{margin:0;padding:16px;background:var(--bg);color:var(--fg);font:15px/1.45 system-ui,sans-serif}}
h1{{font-size:20px;margin:0 0 4px}} .meta{{color:var(--muted);margin-bottom:20px}}
section{{background:var(--card);border-radius:14px;padding:12px 16px 16px;margin-bottom:20px;box-shadow:0 1px 3px rgba(0,0,0,.08)}}
h2{{font-size:17px;margin:0 0 10px}}
.pair{{display:flex;gap:12px;flex-wrap:wrap}} figure{{margin:0;flex:1 1 220px;max-width:360px}}
img{{width:100%;border-radius:12px;display:block;border:1px solid rgba(0,0,0,.08)}}
figcaption{{text-align:center;color:var(--muted);font-size:13px;margin-top:6px}}
</style></head><body>
<h1>{a.title}</h1><div class="meta">{datetime.now().strftime('%Y-%m-%d %H:%M')} · {len(built)} màn</div>
{''.join(cards)}
</body></html>"""
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as fh:
        fh.write(html)
    print("->", a.out, f"({os.path.getsize(a.out)//1024} KB)")


if __name__ == "__main__":
    main()
