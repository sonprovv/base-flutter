# -*- coding: utf-8 -*-
"""Coverage gate: moi control co action "-> X" trong screens.json phai co screenshot cua X.

python .claude/skills/analyze-screens/scripts/coverage.py [output/screens.json] [--md output/screens-coverage.md]
Exit 1 khi con man thieu chua co "resolution" -> analyze-screens phai dung va hoi user.
"""
import io, json, re, sys

# "→ paywall", "→ paywall (inferred)", "→ style_detail(remove-object)", "→ paywall / save"; KHONG khop "→ full preview" (2 tu = mo ta, khong phai screen id)
NAV_RE = re.compile(r"(?:→|->)\s*([a-z][a-z0-9_]*)(?:\s*\([^)]*\))?\s*(?:$|,|/|\|)")
# action khong dan toi man khac (khong tinh la thieu)
LOCAL_ACTIONS = ("← back", "<- back", "dismiss", "back", "auto")
NON_SCREEN = {"back", "home_prev", "save", "share", "system_picker"}


def targets_of(action):
    if not action:
        return []
    a = action.strip()
    if a.lower().startswith(LOCAL_ACTIONS):
        return []
    out = []
    for t in NAV_RE.findall(a):
        t = t.split("(")[0]
        if t not in NON_SCREEN:
            out.append(t)
    return out


def main():
    args = [x for x in sys.argv[1:] if not x.startswith("--")]
    path = args[0] if args else "output/screens.json"
    md_path = "output/screens-coverage.md"
    if "--md" in sys.argv:
        md_path = sys.argv[sys.argv.index("--md") + 1]
    data = json.load(io.open(path, encoding="utf-8"))
    screens = data.get("screens", [])
    ids = {s["id"] for s in screens}
    # man co state/anh phu (vd generate_sheet la bottom_sheet cua crop) van tinh la co
    resolutions = {m["id"]: m for m in data.get("missing_screens", []) if isinstance(m, dict)}

    rows = []  # (from_screen, component_id, text, target, has_shot)
    for s in screens:
        for c in s.get("components", []):
            tg = targets_of(c.get("action"))
            for t in tg:
                rows.append((s["id"], c.get("id"), c.get("text") or c.get("icon") or "", t, t in ids))
            # control tuong tac ma khong ghi action -> cung la lo hong
            if c.get("type") in ("button", "icon_button", "text_button", "fab", "dropdown", "tab", "card", "chip", "list_item", "toggle", "radio", "input") and not c.get("action"):
                rows.append((s["id"], c.get("id"), c.get("text") or c.get("icon") or "", "?", False))
        for t in s.get("navigates_to", []):
            if t not in ids and not any(r[0] == s["id"] and r[3] == t for r in rows):
                rows.append((s["id"], "(navigates_to)", "", t, False))
    for e in data.get("navigation", {}).get("edges", []):
        t = e.get("to")
        if t and t not in ids and not any(r[3] == t for r in rows):
            rows.append((e.get("from"), "(edge)", e.get("trigger", ""), t, False))

    missing = {}
    for f, cid, text, t, ok in rows:
        if not ok:
            missing.setdefault(t, []).append((f, cid, text))

    unresolved = [t for t in missing if t not in resolutions or not resolutions[t].get("resolution")]

    lines = ["# Screens coverage", "", "Nguồn: `%s` — %d màn có ảnh, %d control/cạnh điều hướng đã kiểm." % (path, len(ids), len(rows)), ""]
    lines.append("## Màn có ảnh")
    lines.append(", ".join(sorted(ids)))
    lines.append("")
    lines.append("## Control dẫn tới màn CHƯA có screenshot")
    if not missing:
        lines.append("Không có. Đủ ảnh để đi tiếp.")
    else:
        lines.append("| Màn đích | Kích hoạt từ | Control | Text/icon | Resolution |")
        lines.append("|---|---|---|---|---|")
        for t, srcs in missing.items():
            res = resolutions.get(t, {}).get("resolution") or "**THIẾU — cần user quyết**"
            for f, cid, text in srcs:
                lines.append("| `%s` | %s | `%s` | %s | %s |" % (t, f, cid, text, res))
        lines.append("")
        lines.append("`?` = control tương tác không ghi `action` → phải hỏi/đoán và ghi lại.")
    lines.append("")
    lines.append("## Cần user")
    if unresolved:
        lines.append("Bổ sung screenshot vào `input/screenshots/` cho: " + ", ".join("`%s`" % t for t in unresolved) + ".")
        lines.append("Nếu app gốc không có màn đó / không chụp được, trả lời cho từng màn 1 trong: `hide` (bỏ control), `stub` (toast Coming soon), `design` (tự dựng theo mô tả), `reuse:<screen_id>`.")
    else:
        lines.append("Không còn. Mọi màn thiếu đã có resolution.")
    io.open(md_path, "w", encoding="utf-8").write("\n".join(lines) + "\n")

    print("screens=%d checked=%d missing=%s unresolved=%s -> %s" % (len(ids), len(rows), list(missing), unresolved, md_path))
    sys.exit(1 if unresolved else 0)


if __name__ == "__main__":
    main()
