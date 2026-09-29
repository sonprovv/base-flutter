.PHONY: native get analyze test check run-dev

native:
	./scripts/init_native.sh

get:
	flutter pub get

analyze:
	flutter analyze

test:
	flutter test

check:
	./scripts/check.sh

run-dev:
	flutter run --dart-define=APP_FLAVOR=dev --dart-define=API_BASE_URL=https://example.invalid --dart-define=ENABLE_NETWORK_LOGS=true
