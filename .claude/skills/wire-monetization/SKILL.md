---
name: wire-monetization
description: Bước 6 của Flutter App Factory cho app IAA. Parse Master Plan, tạo ad config, tích hợp Google Mobile Ads Flutter + UMP qua abstraction, map placement vào screen Android/iOS, thêm tracking và verify test ads. Dùng khi user nói gắn ads/wire monetization/master plan.
---

# wire-monetization

Input ưu tiên: `input/<ID> - <Name>_Master Plan.xlsx`; fallback: Ads section trong `output/plan.md`.
Output:
- `output/monetization/app_config.json`;
- `output/monetization/ad_config.json` + `ad_script.md` + `monetization.md`;
- `assets/config/ad_config.json`;
- implementation `lib/core/ads/` + `lib/ui/core/ads/`;
- platform config Android/iOS;
- tracking event constants/mapping.

## Boundary bắt buộc

Feature không import `package:google_mobile_ads/...`.

```text
feature screen
  -> AppAdSlot / AdGateway abstraction
     -> GoogleMobileAds implementation
        -> google_mobile_ads
```

Tương tự tracking chỉ qua `Tracker`.

## Current implementation baseline

Khi skill thực sự kích hoạt monetization, add `google_mobile_ads` version tương thích với Flutter/Dart của repo; tại thời điểm base này được tạo, 9.1.x là current stable. **Luôn kiểm pub.dev/changelog trước khi nâng package**, vì mobile ads native SDK thay đổi nhanh.

UMP consent:
- request consent info update mỗi app launch;
- show form if required;
- chỉ request ads sau khi `canRequestAds()` cho phép;
- nếu privacy options entry point required, Settings phải có entry để user mở lại form;
- test geography/device ID chỉ ở debug config.

## Parse Master Plan

```bash
python .claude/skills/wire-monetization/scripts/parse_master_plan.py \
  "input/<file>.xlsx"
```

Parser tạo app/ad config và so remote-config keys với `lib/core/ads/ad_placements.dart`.

## Mapping placement

Tạo `monetization.md`:

| placement | format | screen/position | trigger | preload | consent gate | Android | iOS | status |

Quy tắc:
- placement yêu cầu screen không tồn tại -> `skipped: no screen`, không tự tạo screen;
- thiếu unit id -> wire được abstraction nếu cần nhưng `enabled=false`;
- ad container không có placement trong plan -> bỏ để tránh khoảng trống;
- rewarded: feature reward chỉ hoàn tất trong reward callback, không trong close callback;
- interstitial/app-open: action tiếp tục flow dù load/show fail;
- banner/native phải dispose/recycle đúng lifecycle;
- không show interstitial bất ngờ ngay sau user tap không liên quan hoặc che system dialog/consent.

## Android config

- AdMob App ID qua manifest meta-data/config per app.
- Không hardcode production unit id trong widget.
- Kiểm tra minSdk/compileSdk theo Flutter/plugin hiện tại.
- Test ad IDs ở debug/test config.

## iOS config

- `GADApplicationIdentifier` trong Info.plist/config per app.
- SKAdNetwork/ATT chỉ cấu hình theo requirement hiện tại của app/SDK/mediation; không copy danh sách cũ mù quáng.
- Nếu mediation plugin yêu cầu deployment target cao hơn, nâng target và ghi `output/platform-changes.md`.

## Ad config model

`assets/config/ad_config.json` ví dụ:

```json
{
  "inter_home": {"enabled": true, "android_id": "...", "ios_id": "..."},
  "reward_feature": {"enabled": false, "android_id": "", "ios_id": ""}
}
```

Nếu Master Plan hiện chỉ có một cột ID Android, **không bịa iOS ID**. Ghi blocker/field thiếu; schema parser vẫn giữ chỗ cho platform-specific ID.

## Tracking

Tên event snake_case, semantic: `home_click_style`, `editor_generate_start`, `editor_generate_success`, `ad_inter_home_show`, ...
Không gửi PII/raw prompt nếu privacy plan không cho phép.

## Verify

- `flutter analyze` + `flutter test`.
- Android device: consent + banner/native/inter/reward test ads.
- iOS simulator/device trên macOS: consent + ad load/show relevant formats.
- Verify privacy options form khi required.
- Không dùng production click để test.

## Không làm

- Không gọi SDK trực tiếp trong feature.
- Không commit secret/MMP token.
- Không fake iOS ad unit ID từ Android ID.
- Không bypass consent gate vì form load lỗi; xử lý theo trạng thái SDK và policy hiện hành.
