# Flutter App Factory Workflow — Screenshots → Android + iOS

## 1. Mục tiêu

Biến bộ screenshot + API spec + product config thành một Flutter app có cấu trúc maintainable, chạy Android/iOS, có test/review gates, và có thể tái sử dụng workflow cho nhiều app.

Workflow giữ 2 checkpoint cho người duyệt:

```text
INPUT
  | screenshots / API / product config
  v
[1] analyze-screens
  v
[2] extract-design
  v
[3] plan-app -------------------- CHECKPOINT 1
  v
[4] integrate-api
  v
[5] design-layout
  v
[5b] generate-assets
  v
[6] wire-monetization (optional/IAA)
  v
[7] qa-release ------------------ CHECKPOINT 2
```

## 2. Input chuẩn

```text
input/
├── screenshots/
│   ├── 01_splash.png
│   ├── 02_onboarding.png
│   └── ...
├── api/
│   └── openapi.json          # optional nếu dùng URL
├── assets/                   # asset do user/team sở hữu
└── <ID> - <Name>_Master Plan.xlsx  # optional cho IAA/product config
```

Bộ screenshot phải bao phủ mọi screen mà control có thể dẫn tới. Coverage gate của bước 1 chặn việc tiếp tục nếu còn màn chưa có screenshot và chưa có resolution do user quyết định.

## 3. Output chuẩn

```text
output/
├── screens.json
├── screens.md
├── screens-coverage.md
├── palette.json
├── design-system.md
├── plan.md
├── api/
├── specs/
├── checks/
├── review/
├── monetization/
├── release/
└── platform-changes.md
```

`output/` là workspace sinh tự động, mặc định gitignore.

## 4. Mapping Android-native cũ → Flutter

| Native Android workflow | Flutter workflow |
|---|---|
| XML/ViewBinding | Flutter widgets + immutable UI state |
| Fragment + BaseFragment | `<Feature>Screen` + reusable UI primitives |
| ViewModel + StateFlow | Riverpod Notifier/AsyncNotifier ViewModel |
| Hilt | Riverpod providers / constructor injection |
| Retrofit | Dio service/data source |
| Room | Chỉ thêm local DB khi feature yêu cầu |
| Activity/Fragment navigation | go_router |
| colors.xml/dimens/styles | AppColors/AppType/AppMetrics/AppTheme |
| adb DebugLauncher | integration_test + route/test harness |
| Android-only release | Android AAB/APK + iOS archive/IPA gate |
| ads SDK gọi trong feature | `AdGateway`/ad widget adapter boundary |

## 5. Definition of Done cho một screen

Một screen chỉ được coi là xong khi:
- Layout/state chính bám spec và review screenshot.
- Mọi interactive control có action thực hoặc resolution rõ ràng.
- Không overflow/clip ở text scale 1.0 và kiểm tra tối thiểu một text scale lớn hơn.
- Không crash khi loading/error/empty.
- ViewModel logic có test nếu có branch/business logic.
- Widget test kiểm action quan trọng hoặc integration flow bao phủ.
- Không có SDK/data access gọi trực tiếp trong widget.

## 6. Definition of Done cho release

- `dart format` sạch.
- `flutter analyze` sạch Error; warning được review.
- `flutter test` pass.
- P0 integration flow pass Android; iOS pass trên macOS/Xcode trước App Store release.
- App id/bundle id, display name, version, icons, privacy URL, permission purpose strings đã thay per-app.
- Không còn placeholder/base brand hoặc secret trong repo.
- Ads consent/config đúng nếu monetization bật.
- Store metadata và review screenshots được người duyệt xác nhận.
