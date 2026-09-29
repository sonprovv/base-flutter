---
name: analyze-screens
description: Bước 1 của Flutter App Factory. Đọc toàn bộ screenshot trong input/screenshots, đo layout theo Flutter logical pixels, sinh output/screens.json + screens.md + coverage gate. Dùng khi bắt đầu app mới, user nói analyze screens/phân tích màn hình/đọc screenshot.
---

# analyze-screens

Input: `input/screenshots/*.{png,jpg,jpeg,webp}`.
Output: `output/screens.json`, `output/screens.md`, `output/screens-coverage.md`.

Skill này **chỉ mô tả UI/flow nhìn thấy**, không quyết định giữ/bỏ/gộp và không sinh code. `plan-app` mới quyết định product flow; `extract-design` mới quyết định design token.

Mục tiêu: `design-layout` có thể dựng screen từ `screens.json` mà không phải đo lại ảnh.

## Quy trình

1. List toàn bộ screenshot, sort theo prefix số hoặc flow do user đặt. Nếu không có ảnh: dừng và báo thiếu input.
2. Đọc từng ảnh. Với mỗi screen/state ghi:
   - resolution gốc;
   - layout structure, regions, scroll/fixed;
   - component nhìn thấy;
   - text nguyên văn để đối chiếu (không mặc định dùng lại trong app mới);
   - action/navigation;
   - state: default/loading/empty/error/selected/dialog/sheet;
   - safe-area/system-bar behavior.
3. Đo component theo 2 hệ:
   - `box_pct: [x,y,w,h]` theo % ảnh;
   - `box_lp: [x,y,w,h]` theo Flutter logical pixel reference 360 logical px chiều rộng: `lp = px / (width_px/360)`.
4. Với list/grid/carousel ghi `item_box_lp`, `gap_lp`, `padding_lp`, orientation, số item visible/peek.
5. Với text ghi estimated `text_size_lp`, weight, alignment, max lines/ellipsis nếu nhìn thấy.
6. Với card/button ghi `corner_lp`; icon/avatar ghi size.
7. Suy ra navigation graph. Cạnh suy luận phải `inferred: true`.
8. Chạy coverage gate. Mọi interactive control phải có action; mọi route target phải có screen hoặc resolution do user chọn.

Script đo:

```bash
python .claude/skills/analyze-screens/scripts/measure.py input/screenshots/05_home.png --grid
python .claude/skills/analyze-screens/scripts/measure.py input/screenshots/05_home.png --boxes
```

Coverage:

```bash
python .claude/skills/analyze-screens/scripts/coverage.py output/screens.json --md output/screens-coverage.md
```

Exit != 0 -> **dừng workflow** cho đến khi user bổ sung screenshot hoặc chọn resolution.

## Coverage resolution

Cho màn thiếu ảnh, user chọn một trong:
- `hide`: bỏ control khỏi app mới.
- `stub`: control tồn tại nhưng explicit unavailable/coming soon; không route chết.
- `design`: tự thiết kế screen mới, ghi rõ là original/new trong plan.
- `reuse:<screen_id>`: route sang screen đã có.

Không tự chọn thay user khi thiếu màn ảnh tham khảo.

## Schema cốt lõi

```json
{
  "source": {"count": 10, "generated_at": "ISO date"},
  "app_summary": "...",
  "screens": [
    {
      "id": "home",
      "file": "05_home.png",
      "name": "Home",
      "type": "screen",
      "purpose": "...",
      "layout": {
        "structure": "scroll",
        "safe_area": {"top": true, "bottom": true},
        "regions": [],
        "tree": "Scaffold > SafeArea > CustomScrollView > ..."
      },
      "components": [
        {
          "id": "btn_home_start",
          "type": "button",
          "text": "Start",
          "box_pct": [5, 80, 90, 7],
          "box_lp": [18, 650, 324, 56],
          "corner_lp": 16,
          "text_size_lp": 16,
          "style_hint": "filled rounded",
          "action": "-> editor"
        }
      ],
      "states": [{"name": "default", "file": "05_home.png"}],
      "texts": ["Start"],
      "navigates_to": ["editor"],
      "uncertain": []
    }
  ],
  "missing_screens": [],
  "navigation": {"entry": "splash", "edges": []},
  "shared_components": [],
  "uncertain": []
}
```

## Key naming cho Flutter

`components[].id` trở thành `ValueKey` trong widget/integration test khi control tương tác:
- `btn_home_start`
- `iconbtn_home_settings`
- `card_home_style_0`
- `tab_editor_crop`
- `input_prompt_text`

Không dùng key theo text hiển thị vì localization làm key không ổn định.

## Kiểm tra trước khi kết thúc

- coverage.py exit 0;
- interactive control nào cũng có action;
- component chính đều có box;
- list/grid có item box + gap;
- screen có state tối thiểu hợp lý;
- system status/navigation bar không bị tính là app component;
- không copy asset hay sinh code.
