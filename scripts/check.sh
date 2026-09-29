#!/usr/bin/env bash
set -euo pipefail

flutter pub get

paths=(lib test)
if [[ -d integration_test ]]; then
  paths+=(integration_test)
fi

dart format --output=none --set-exit-if-changed "${paths[@]}"
flutter analyze
flutter test
