---
name: qa-release
description: Bước 7 của Flutter App Factory, checkpoint 2. Kiểm per-app config, format/analyze/test, integration flow, build Android AAB/APK và iOS archive/IPA khi có macOS, review screenshots, permissions/privacy/ads/store checklist. Dùng khi chuẩn bị release.
---

# qa-release

Input: repo sau implementation, `output/plan.md`, assets manifest, monetization config nếu có, product config/ASO.
Output:
- `output/release/checklist.md`;
- `output/release/review.md` + screenshots;
- logs format/analyze/test/build;
- `output/release/store-metadata.md`;
- Android artifact; iOS artifact khi môi trường/signing cho phép.

## 1. Per-app identity gate

Kiểm tra:
- `pubspec.yaml` name nội bộ phù hợp;
- Android `applicationId`/namespace/flavor;
- iOS bundle identifier/scheme;
- display name hai platform;
- version/build number;
- app icon / launch treatment;
- API endpoints/flavor;
- Firebase/MMP/AdMob config đúng app;
- privacy policy URL;
- không còn `com.example`, `Flutter App Factory Base`, sample API hoặc test placeholder trong release config.

Không tự bịa service key/signing credential. Thiếu -> BLOCKER.

## 2. Static quality

```bash
mkdir -p output/release
./scripts/check.sh > output/release/check.log 2>&1
flutter pub outdated > output/release/pub-outdated.log 2>&1 || true
```

Review warning, deprecated API, plugin platform support. Không auto-upgrade package major ở bước release.

## 3. Integration test

P0 flow chạy deterministic test backend/fake khi có thể:

```bash
flutter test integration_test
```

Hoặc chạy device cụ thể theo Flutter CLI/team CI. Android và iOS đều phải có evidence trước production release; nếu host không phải macOS, iOS build/test ghi BLOCKER/needs-mac, không đánh dấu pass.

## 4. Android build

```bash
flutter build appbundle --release --flavor production \
  > output/release/android-build.log 2>&1
```

Nếu repo không dùng flavor, bỏ `--flavor`. Signing lấy từ env/key.properties secret store, không hardcode.

Kiểm:
- permissions thực sự cần;
- exported components/deep links;
- app size;
- crash startup/offline/API failure;
- target/compile requirements hiện hành;
- page-size/native library compatibility nếu plugin có native code.

## 5. iOS build

Trên macOS/Xcode:

```bash
flutter build ipa --release --flavor production \
  > output/release/ios-build.log 2>&1
```

Nếu signing chưa sẵn sàng, có thể build config/unsigned test phù hợp workflow team nhưng release checklist phải ghi rõ chưa có archive signed.

Kiểm:
- bundle id/team/provisioning;
- Info.plist permission purpose strings;
- URL schemes/associated domains/capabilities;
- iOS deployment target tương thích plugin;
- privacy manifest/SDK declarations theo yêu cầu hiện hành.

## 6. UI review

- Screenshot mọi P0/P1 screen + loading/error/empty quan trọng.
- Test nhỏ/lớn device; ít nhất một Android và một iPhone form factor.
- Check text scale tăng, safe area, keyboard, rotation nếu app hỗ trợ, dark mode nếu plan có.
- `review_page.py` tạo trang review cho non-dev.

## 7. Functional checklist

`checklist.md` mỗi mục ✅/⚠️/❌ + evidence:
- no dead control; coverage.py pass;
- back/navigation/deep link hợp lý;
- offline/timeout/401/500 path;
- no crash on resume/background;
- secure token không log;
- permission only when needed;
- asset ownership manifest đóng;
- no reference app brand/text/asset leak;
- analytics/ads consent theo product/policy;
- privacy options accessible nếu ads SDK yêu cầu;
- reward không cấp sai khi ad fail/skip.

## 8. Store metadata

Tách Android/iOS fields:
- title/subtitle/short/full description theo giới hạn store hiện hành;
- category;
- privacy URL;
- support URL nếu cần;
- screenshots list từ review;
- content/data-safety/privacy answers **dựa trên SDK/data flow thật**, không copy boilerplate app khác.

Nếu giới hạn store/policy có thể thay đổi, kiểm documentation hiện hành trước khi chốt con số.

## Kết thúc

Tóm tắt theo 3 nhóm:
- BLOCKER: bắt buộc xử lý trước production;
- WARNING: cần review;
- PASS + artifact/evidence paths.

Dừng ở checkpoint 2 để người duyệt APK/AAB/iOS build + review screenshots.
