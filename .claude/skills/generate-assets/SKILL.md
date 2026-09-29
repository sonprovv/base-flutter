---
name: generate-assets
description: Bước 5b của Flutter App Factory. Tạo/nhập asset hợp lệ cho app Flutter (hero, onboarding, samples, icons), tối ưu vào assets/images, cập nhật manifest nguồn và pubspec. Không copy asset app tham khảo. Dùng sau design-layout khi assets-needed.md còn mục mở.
---

# generate-assets

Input: `output/assets-needed.md`, `output/plan.md`, `output/design-system.md`, API sample có URL ảnh, `input/assets/` nếu user cung cấp.
Output:
- `assets/images/asset_*.webp|png`;
- `output/assets-manifest.md`;
- mapping asset tập trung nếu feature cần;
- icon source 1024x1024 và hướng dẫn/generation cho Android+iOS launcher icon.

## Rule 0 — phân loại asset

1. **Runtime API image**: load bằng URL ở runtime; không bundle chỉ vì screenshot có nó.
2. **App-owned bundle asset**: splash/onboarding/hero/sample/icon cần offline -> bundle.
3. **Reference screenshot asset**: chỉ để phân tích; **không bundle/copy**.

## Nguồn ưu tiên

1. Asset user/team cung cấp trong `input/assets/` với quyền dùng rõ.
2. Backend/team asset URL được phép bundle, nếu product owner xác nhận.
3. Asset sinh bằng công cụ image generation theo prompt mới, không sao chép artwork/brand reference.
4. Procedural Flutter shape/gradient cho placeholder non-production.

Không dùng Google Images/asset scrape/app APK khác.

## Quy trình

1. Đọc `assets-needed.md`, ghi kích thước/aspect/use case.
2. Chuẩn hóa tên: `asset_<feature>_<purpose>_<n>.webp`.
3. Resize theo use case; ưu tiên WebP cho raster không cần alpha đặc biệt.
4. Tổng bundle raster phải được kiểm soát; không bundle hàng chục preview mà API đã phục vụ.
5. Dùng contact sheet review:

```bash
python .claude/skills/generate-assets/scripts/contact_sheet.py \
  assets/images output/review/assets_sheet.png
```

6. Nếu import URL hợp lệ từ team/API:

```bash
python .claude/skills/generate-assets/scripts/fetch_examples.py
```

7. Nếu tool image generation xuất URL JSON `{name:url}`:

```bash
python .claude/skills/generate-assets/scripts/import_generated.py \
  output/assets/generated/export_urls.json
```

8. Update `assets-manifest.md`: use, file, source, license/ownership, prompt nếu generated, size.
9. `flutter pub get` + run screens dùng asset.

## Launcher icon

Skill này chỉ tạo **source master** `assets/brand/app_icon_1024.png` hoặc nhận từ user. Platform launcher set có thể:
- dùng tool/project plugin team đã chuẩn hóa; hoặc
- generate native assets trong qa-release/platform setup.

Không tự thêm package launcher icon nếu repo policy chưa cho phép. Nếu icon source thiếu -> BLOCKER release.

## Không làm

- Không bundle reference screenshot.
- Không copy logo/trademark app khác.
- Không nhúng URL tạm hết hạn làm runtime source.
- Không để placeholder procedural qua release mà không warning/blocker.
