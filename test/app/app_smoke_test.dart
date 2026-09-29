import 'package:flutter_app_factory_base/app/app.dart';
import 'package:flutter_app_factory_base/core/config/app_config.dart';
import 'package:flutter_app_factory_base/core/config/providers.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders the base home screen', (tester) async {
    SharedPreferences.setMockInitialValues({
      'completed_onboarding': true,
      'open_count': 2,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prefsServiceProvider.overrideWithValue(PrefsService(prefs)),
          appConfigProvider.overrideWithValue(
            const AppConfig(
              flavor: AppFlavor.dev,
              apiBaseUrl: 'https://example.invalid',
              enableNetworkLogs: false,
            ),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();

    expect(find.text('BabyGenie'), findsOneWidget);
  });
}
