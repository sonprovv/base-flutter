# Environments and native flavors

The Dart side is already environment-aware through `--dart-define`:

```bash
flutter run \
  --dart-define=APP_FLAVOR=dev \
  --dart-define=API_BASE_URL=https://dev.example.com \
  --dart-define=ENABLE_NETWORK_LOGS=true
```

For staging/production, change the values and disable network-body logs in production.

## Native Android/iOS flavors

Use native flavors only when you need distinct bundle/application IDs, app display names, icons, Firebase files, signing, or store tracks.

### Android

Define a flavor dimension and `productFlavors` in `android/app/build.gradle.kts`, for example `dev`, `staging`, `prod`, then run:

```bash
flutter run --flavor dev --dart-define=APP_FLAVOR=dev
flutter build appbundle --flavor prod --dart-define=APP_FLAVOR=prod
```

### iOS

Create matching Xcode schemes/configurations (`dev`, `staging`, `prod`) and assign distinct bundle identifiers as needed, then run:

```bash
flutter run --flavor dev --dart-define=APP_FLAVOR=dev
flutter build ipa --flavor prod --dart-define=APP_FLAVOR=prod
```

Keep native flavor names aligned across Android, iOS, and `APP_FLAVOR` to reduce CI mistakes.
