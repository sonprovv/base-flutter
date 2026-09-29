# CLAUDE.md — Flutter App Factory Base (Android + iOS)

Repo này là **BASE** để sinh nhiều app Flutter từ screenshot + API spec + product plan. Base cung cấp kiến trúc, conventions, tooling và skill workflow; visual design của từng app được trích từ input riêng. Không commit `input/`, `output/`, secret, signing key hay file service production vào base.

## Stack & platform baseline

- Flutter stable 3.47-era; Dart >= 3.12.
- Android API 24+; iOS 15+ mặc định. Không tự hạ deployment target dưới mức Flutter stable đang hỗ trợ.
- Riverpod 3.x: dependency injection + ViewModel state.
- go_router 18.x: navigation, redirect, deep link.
- Dio 5.x: HTTP, interceptor, cancellation.
- flutter_secure_storage 11.x: token/secret.
- Equatable: immutable value equality, không bắt buộc codegen.
- flutter_test + integration_test + mocktail.
- Monetization là module kích hoạt theo skill; feature không được import `google_mobile_ads` trực tiếp.

## Kiến trúc cứng

Dependency direction trong một feature:

```text
Screen / View
  -> ViewModel (Riverpod)
    -> UseCase (chỉ khi business intent đáng đặt tên)
      -> Repository contract (domain)
        <- Repository implementation (data)
          -> Remote/Local Service
```

Rules:
1. `presentation` không import `data`. Wiring concrete implementation qua provider/composition root.
2. `domain` không import Flutter, Dio, platform plugin, secure storage hay presentation.
3. `data` implement domain contract; DTO không đi thẳng lên UI.
4. Repository là source of truth. Service chỉ bọc data source, không giữ UI state.
5. Use case **không bắt buộc cho mọi method**; thêm khi có orchestration/rule/reuse đáng kể.
6. Một feature không import `data`/`presentation` của feature khác. Share qua domain contract hoặc chuyển code thực sự cross-cutting vào `core`.
7. Riverpod provider là composition/wiring; business logic không nằm trong provider closure dài.

## Convention UI / design tokens

1. Cấm hardcode `Color(0x...)` trong feature UI. Màu đi qua `Theme.of(context).colorScheme`, `AppColors` hoặc semantic theme extension.
2. Spacing/radius/size lặp lại dùng `AppMetrics`. Số đo chỉ riêng một màn được đặt trong `<feature>_metrics.dart`, không rải magic numbers.
3. Typography đi qua `Theme.of(context).textTheme` hoặc `AppType`; không tự tạo font size tùy tiện trong mỗi widget.
4. Shared component đặt ở `lib/ui/core/`. Component có nghĩa nghiệp vụ đặt trong feature.
5. Interactive control cần `Key` ổn định theo snake_case để integration test/review: `ValueKey('btn_home_start')`, `ValueKey('card_home_style_0')`.
6. Screen file: `<name>_screen.dart`; ViewModel: `<name>_view_model.dart`; state riêng: `<name>_state.dart`; repository: `<name>_repository.dart`; implementation: `<name>_repository_impl.dart`.
7. Không nhét data/API logic vào `build()`. View chỉ render immutable state và forward event.
8. Loading/error/empty phải là state có chủ đích; không để Future treo hoặc exception raw hiển thị trực tiếp cho user.
9. Responsive theo constraints/MediaQuery; không scale toàn màn bằng một tỉ lệ cố định. Screenshot chuẩn hóa ở 360 logical px ngang là reference, không phải kích thước duy nhất.
10. SafeArea/system insets: quyết định theo từng region. Full-bleed background có thể tràn, interactive content phải tránh notch/home indicator.

## Navigation

- Chỉ route qua `go_router` hoặc abstraction đã có trong `app/router`.
- Route path/name nằm tập trung; không hardcode string route rải ở feature.
- Mọi control điều hướng trong `screens.json` phải map tới route hoặc explicit local action. Không nút chết.
- Auth/onboarding redirect xử lý ở router/app state, không copy logic redirect vào nhiều screen.

## Network / storage

- Base URL từ `AppConfig`, không hardcode production host trong feature.
- Dio instance dùng chung từ `dioProvider`; feature tạo service/data source trên instance đó.
- Map Dio error -> `AppException`/`Result` ở data boundary.
- Token, refresh token, credential -> `SecureStorage`; preference không nhạy cảm mới dùng preference store khi được thêm.
- Không log token, authorization header, PII hoặc raw production response chứa dữ liệu nhạy cảm.

## Ads / analytics boundary

- Feature **không import** SDK ads/analytics/MMP trực tiếp.
- Ads đi qua `lib/core/ads/` abstraction + widget adapter trong `lib/ui/core/ads/` khi skill monetization kích hoạt.
- Tracking đi qua `Tracker`; event name snake_case, định nghĩa tập trung.
- UMP/consent phải hoàn tất state update trước ad request; luôn kiểm tra khả năng request ads.
- Android/iOS app id, unit id, MMP token, Firebase config là per-app config; không hardcode secret vào Dart source.

## Screenshot-to-UI policy

- Screenshot là tài liệu layout/flow, không phải nguồn asset để copy.
- Không lấy logo, ảnh, illustration, icon độc quyền hay text marketing nguyên văn của app tham khảo để bundle.
- `analyze-screens` mô tả và đo; `extract-design` lấy token; `plan-app` quyết định differentiation; `design-layout` dựng UI bằng Flutter widget.
- Mục tiêu là parity về cấu trúc và chất lượng UX cần thiết cho spec, đồng thời app mới phải có product identity/asset/text hợp lệ riêng.

## Testing gates

Sau thay đổi code đáng kể:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test integration_test 2>/dev/null || true
flutter analyze
flutter test
```

Cho màn hình/flow:
- ViewModel/repository/service: unit test.
- Screen: widget test cho state + action quan trọng.
- Route/flow P0: integration_test trên Android và iOS ít nhất trước release.
- Screenshot fidelity: dùng review screenshot + golden/image diff khi có baseline ổn định.

## Native platform rule

- Không chỉnh Gradle/Xcode template chỉ để “cho giống base cũ”. Dùng `flutter create` của SDK cài trên máy.
- Chỉ sửa `android/`/`ios/` khi plugin, flavor, signing, permission, URL scheme, associated domain hoặc capability yêu cầu.
- Mọi thay đổi native phải ghi trong `output/platform-changes.md` để release review được.
- iOS build/release cần macOS + Xcode; nếu môi trường hiện tại không có macOS, ghi BLOCKER thay vì giả vờ build IPA thành công.

## Skills

`analyze-screens` → `screens.json` + coverage gate · `extract-design` → design system + Flutter token slots · `plan-app` → feature/route/API/platform plan (checkpoint 1) · `integrate-api` → Dio service + repository + sample/mock · `design-layout` → Flutter Screen/ViewModel/widgets + screenshot review · `generate-assets` → legal app assets under `assets/` · `wire-monetization` → Google Mobile Ads/UMP through abstraction, both Android/iOS · `qa-release` → analyze/test/build/review/store checklist (checkpoint 2).

## Bắt đầu app mới

1. Clone base sạch -> branch `app/<name>`.
2. `ORG=... PROJECT_NAME=... ./scripts/init_native.sh` để tạo Android/iOS shell từ Flutter hiện tại.
3. Đặt vào `input/`: screenshots đủ flow, API/Swagger URL hoặc spec file, Master Plan nếu app IAA, assets hợp lệ nếu có.
4. Chạy skill theo thứ tự trong `FLUTTER_APP_FACTORY_WORKFLOW.md`.
5. Mọi artifact trung gian ghi vào `output/` và không commit trừ khi team chủ động muốn lưu.
