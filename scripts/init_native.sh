#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${PROJECT_NAME:-flutter_app_factory_base}"
ORG="${ORG:-com.example}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter command not found. Install current Flutter stable first." >&2
  exit 1
fi

flutter create \
  --empty \
  --platforms=android,ios \
  --android-language=kotlin \
  --org "$ORG" \
  --project-name "$PROJECT_NAME" \
  "$TMP_DIR/native"

rm -rf "$ROOT_DIR/android" "$ROOT_DIR/ios"
cp -R "$TMP_DIR/native/android" "$ROOT_DIR/android"
cp -R "$TMP_DIR/native/ios" "$ROOT_DIR/ios"
cp "$TMP_DIR/native/.metadata" "$ROOT_DIR/.metadata"

# Flutter 3.47 supported-platform baseline: Android 24+, iOS 15+.
ANDROID_GRADLE="$ROOT_DIR/android/app/build.gradle.kts"
if [[ -f "$ANDROID_GRADLE" ]]; then
  sed -i.bak 's/minSdk = flutter.minSdkVersion/minSdk = 24/' "$ANDROID_GRADLE" && rm -f "$ANDROID_GRADLE.bak"
fi

IOS_PODFILE="$ROOT_DIR/ios/Podfile"
if [[ -f "$IOS_PODFILE" ]]; then
  if grep -q "^# platform :ios" "$IOS_PODFILE"; then
    sed -i.bak "s/^# platform :ios.*/platform :ios, '15.0'/" "$IOS_PODFILE" && rm -f "$IOS_PODFILE.bak"
  elif grep -q "^platform :ios" "$IOS_PODFILE"; then
    sed -i.bak "s/^platform :ios.*/platform :ios, '15.0'/" "$IOS_PODFILE" && rm -f "$IOS_PODFILE.bak"
  fi
fi

cd "$ROOT_DIR"
flutter pub get

echo "Native Android/iOS projects created for $PROJECT_NAME ($ORG)."
echo "Next: ./scripts/check.sh"
