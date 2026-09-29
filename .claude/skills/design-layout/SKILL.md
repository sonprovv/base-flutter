---
name: design-layout
description: Bước 5 của Flutter App Factory. Dựng từng screen từ plan/screens/design-system bằng Flutter widgets + Riverpod ViewModel, responsive layout và test; chạy vòng screenshot review/golden diff tối đa 3 lần. Dùng khi user yêu cầu làm UI hoặc sau integrate-api.
---

# design-layout

Input: `output/plan.md`, `output/screens.json`, `output/design-system.md`, API sample/mock, screenshot reference.
Output per screen:
- `output/specs/<screen>.md`;
- Flutter code trong `features/<feature>/presentation`;
- tests tương ứng;
- `output/checks/<screen>_vN.png` + diff/report khi có device;
- `output/assets-needed.md` cho asset chưa có nguồn hợp lệ.

## Mục tiêu

Bám layout/interaction spec nhưng dùng Flutter idiom, không “dịch XML sang widget”. Widget tree phải maintainable, responsive, testable và không vi phạm architecture.

## A. Viết spec trước code

Mỗi screen spec gồm:
- tree/widget regions;
- dimensions/token mapping;
- safe area/full bleed behavior;
- component table: id/key, box reference, style, action;
- state table: loading/error/empty/data/selected;
- data mapping;
- responsive rules;
- accessibility/semantics;
- differences so với reference theo plan;
- asset slots cần.

## B. Widget rules

1. Screen root ưu tiên `Scaffold`; content dùng `SafeArea`, `CustomScrollView`, `ListView`, `GridView`, `LayoutBuilder` tùy spec.
2. Không dùng `Stack/Positioned` cho toàn màn nếu layout thực chất là flow/column/list; Stack chỉ cho overlay/layer thực sự.
3. Không fix screen height theo 812/844. Chỉ dùng screenshot 360lp làm reference; content phải thích ứng device.
4. Fixed CTA bottom phải tính `MediaQuery.paddingOf(context).bottom`/SafeArea.
5. Keyboard/input screen phải test resize + scroll.
6. Text tĩnh quan trọng không cắt bằng `maxLines:1` chỉ để khớp ảnh. Cho wrap/flexible hoặc adaptive layout.
7. Interactive widget gắn stable `ValueKey` từ screens.json.
8. Icon dùng Material/Cupertino hợp lệ hoặc asset/icon riêng của app; không scrape icon app tham khảo.
9. Color/spacing/typography qua token/theme; screen-specific metric gom một file.

## C. ViewModel rules

- Riverpod `Notifier`/`AsyncNotifier` hoặc provider phù hợp với lifecycle.
- ViewModel expose immutable render state + command method.
- Widget không gọi repository/data source trực tiếp.
- Side effect navigation/snackbar/dialog: giữ boundary rõ; không lưu BuildContext trong ViewModel.
- Một lần user action không được trigger API nhiều lần vì rebuild.

## D. Mock/review mode

Mỗi P0/P1 screen phải có cách inject deterministic fake data qua provider override để screenshot/integration test không phụ thuộc network production.

Không thêm “debug launcher Activity”; Flutter dùng test harness/provider override/route initialLocation.

## E. Screenshot verification

Nếu có emulator/device:
1. Chạy app/integration target với fake data.
2. Chụp screenshot built.
3. Đặt reference copy là `<screen>_ref.png` trong `output/review/` (workspace, không bundle).
4. Chạy image diff helper:

```bash
python .claude/skills/design-layout/scripts/image_diff.py \
  output/review/home_ref.png output/review/home.png \
  --out output/checks/home_diff.png
```

5. Sửa tối đa 3 vòng theo thứ tự: geometry -> typography -> color -> polish.

Không dùng pixel-perfect score làm gate duy nhất: system font rendering, platform status bars và dynamic content có thể khác. Gate chính là structure/action/state + review.

Tạo HTML review:

```bash
python .claude/skills/design-layout/scripts/review_page.py \
  --dir output/review --out output/review/index.html
```

## F. Tests

Per feature:
- ViewModel unit test cho branch/error/business action;
- widget test default/loading/error/empty nếu state có;
- tap key quan trọng verify command/navigation;
- P0 flow vào `integration_test/`.

## Kết thúc screen

- `flutter analyze` pass;
- relevant `flutter test` pass;
- mọi control trong spec có implementation;
- no RenderFlex overflow/log error;
- assets chưa hợp lệ được ghi `assets-needed.md`, không lấy tạm từ reference rồi quên thay.
