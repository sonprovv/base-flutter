---
name: extract-design
description: Bước 2 của Flutter App Factory. Phân tích screenshot/pixel để lấy palette và design language, sau đó cập nhật 4 Flutter theme slot app_colors.dart, app_type.dart, app_metrics.dart, app_theme.dart và sinh output/design-system.md. Dùng sau analyze-screens hoặc khi user yêu cầu lấy design system từ screenshot.
---

# extract-design

Input: `input/screenshots/*`, `output/screens.json`.
Output:
- `output/palette.json`, `output/palette.png`;
- `output/design-system.md`;
- cập nhật **giá trị**, không đổi tên semantic slot trong:
  - `lib/app/theme/app_colors.dart`
  - `lib/app/theme/app_type.dart`
  - `lib/app/theme/app_metrics.dart`
  - `lib/app/theme/app_theme.dart`

## Nguyên tắc

- Màu: lấy bằng script trước, AI chỉ gán semantic role.
- Typography/radius/spacing: suy ra từ nhiều screen, không từ một pixel đơn lẻ.
- Token phải semantic; feature UI không biết hex cụ thể.
- Không add package font chỉ vì nhìn “giống”. Nếu font exact không có quyền sử dụng, chọn system typography gần nhất và ghi note.
- Không copy icon/asset của app tham khảo.

## Quy trình

### 1. Palette

```bash
python .claude/skills/extract-design/scripts/palette.py \
  input/screenshots \
  --out output/palette.json \
  --swatch output/palette.png
```

Đọc dominant/background/accent/text/gradient candidates trên 3-5 màn đại diện.

### 2. Gán semantic slots

`AppColors` giữ tên cố định:
- primary / onPrimary / primaryContainer
- secondary / onSecondary
- background / onBackground
- surface / onSurface / surfaceVariant / onSurfaceVariant
- outline / error / onError
- textPrimary / textSecondary / textHint
- divider / scrim

`AppType` giữ scale cố định: display/title/subtitle/body/caption/button.

`AppMetrics` giữ:
- spaceXxs..spaceXxl
- screenPaddingHorizontal
- radiusS/M/L/XL/Pill
- buttonHeight / toolbarHeight
- iconS/M/L

Nếu app cần metric đặc thù màn, **không thêm vào global token**. Ghi yêu cầu vào design-system để design-layout tạo `<feature>_metrics.dart`.

### 3. Component themes

Trong `AppTheme`, map token sang Material 3:
- ColorScheme
- TextTheme
- FilledButton/OutlinedButton/TextButton theme
- Card/InputDecoration/AppBar/NavigationBar/Dialog theme nếu app dùng

Không sửa screen để “chữa” theme ở bước này.

### 4. Accessibility sanity

- Text body/CTA quan trọng phải có contrast hợp lý; nếu screenshot gốc contrast kém, ghi `reference_issue` và ưu tiên readable output.
- Không khóa textScaleFactor.
- Touch target nhỏ trong screenshot: ghi cảnh báo để design-layout giữ visual size nhưng hit target >= hợp lý bằng padding/InkResponse.

### 5. Verify

```bash
./scripts/check.sh
```

Nếu Flutter shell chưa được init, tối thiểu kiểm syntax/file diff và ghi BLOCKER build.

## Mẫu design-system.md

```md
# Design System — App
## Palette
| role | hex | source screens |
## Typography
| role | size | weight | line height |
## Spacing & radius
## Component recipes
## System bars / light-dark behavior
## Responsive notes
## Reference issues / accessibility adjustments
## Notes for design-layout
```

## Không làm

- Không sinh feature/screen.
- Không hardcode asset từ screenshot.
- Không đổi architecture/dependency.
- Không tạo hàng chục token chỉ để khớp một screen.
