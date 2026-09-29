# Flutter App Factory — Clean Architecture Skill Base

Bộ base + Claude skills để dựng app Flutter Android/iOS từ screenshot, API spec và cấu hình sản phẩm. Đây là bản tái thiết lập từ workflow Android native sang Flutter, giữ tinh thần **App Factory** nhưng dùng kiến trúc Flutter hiện đại, feature-first và Clean Architecture thực dụng.

## Baseline

- Flutter stable 3.47-era, Android API 24+, iOS 15+.
- Dart SDK `>=3.12.0 <4.0.0`.
- Riverpod cho DI + state/view model.
- `go_router` cho navigation/deep links.
- Dio cho networking.
- `flutter_secure_storage` cho token/secret.
- `flutter_test` + `integration_test` + Mocktail.
- Không bắt buộc code generation trong base.
- Native Android/iOS shell được sinh bằng Flutter SDK đang cài, tránh giữ Gradle/Xcode template cũ trong base.

## Workflow skill

```text
analyze-screens
  -> extract-design
  -> plan-app             [Checkpoint 1]
  -> integrate-api
  -> design-layout
  -> generate-assets
  -> wire-monetization    [nếu app IAA]
  -> qa-release           [Checkpoint 2]
```

Skills nằm ở `.claude/skills/<name>/SKILL.md`.

## Khởi tạo native shell

```bash
chmod +x scripts/init_native.sh scripts/check.sh
ORG=com.yourcompany PROJECT_NAME=your_app ./scripts/init_native.sh
```

Sau đó:

```bash
flutter run \
  --dart-define=APP_FLAVOR=dev \
  --dart-define=API_BASE_URL=https://api.example.com \
  --dart-define=ENABLE_NETWORK_LOGS=true
```

## Quality gate

```bash
./scripts/check.sh
```

Chạy format check, analyze và test. Khi có `integration_test/`, skill `qa-release` chịu trách nhiệm chạy device flow tương ứng.

## Cấu trúc chính

```text
lib/
├── app/                    # bootstrap, router, theme
├── core/                   # config, network, storage, error, result, infra interfaces
├── ui/core/                # shared presentation widgets
└── features/
    └── <feature>/
        ├── domain/         # entity, repository contract, use case khi cần
        ├── data/           # DTO, service/data source, repository impl
        └── presentation/   # screen, view model, feature widgets
```

Xem `CLAUDE.md`, `FLUTTER_APP_FACTORY_WORKFLOW.md`, `docs/ARCHITECTURE.md` và từng `SKILL.md` để chạy workflow.
