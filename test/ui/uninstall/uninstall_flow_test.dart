import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/app.dart';
import 'package:flutter_app_factory_base/core/config/app_config.dart';
import 'package:flutter_app_factory_base/core/config/providers.dart';
import 'package:flutter_app_factory_base/core/services/shortcut_uninstall_service.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_app_factory_base/ui/uninstall/ask_uninstall_screen.dart';
import 'package:flutter_app_factory_base/ui/uninstall/uninstall_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockShortcutUninstallService extends ShortcutUninstallService {
  MockShortcutUninstallService({this.mockInitialRoute}) : super();

  final String? mockInitialRoute;
  bool didCallUninstallApp = false;
  bool didCallOpenAppSettings = false;
  bool didCallCreateShortcut = false;

  @override
  Future<String?> getInitialRoute() async => mockInitialRoute;

  @override
  Future<bool> createUninstallShortcut() async {
    didCallCreateShortcut = true;
    return true;
  }

  @override
  Future<bool> openAppSettings() async {
    didCallOpenAppSettings = true;
    didCallUninstallApp = true;
    return true;
  }

  @override
  Future<bool> uninstallApp() async {
    didCallUninstallApp = true;
    return true;
  }
}

void main() {
  testWidgets('navigates to UninstallScreen when launched from uninstall shortcut', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final mockService = MockShortcutUninstallService(mockInitialRoute: '/uninstall');

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
          shortcutUninstallServiceProvider.overrideWithValue(mockService),
        ],
        child: const App(),
      ),
    );

    // Wait for splash transition
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify UninstallScreen is shown
    expect(find.byType(UninstallScreen), findsOneWidget);
    expect(
      find.text('We’re truly sorry if we haven’t met your expectations.'),
      findsOneWidget,
    );

    // Tap "Still want to uninstall"
    final stillUninstallBtn = find.byKey(const ValueKey('btn_still_uninstall'));
    expect(stillUninstallBtn, findsOneWidget);
    await tester.tap(stillUninstallBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify AskUninstallScreen is shown
    expect(find.byType(AskUninstallScreen), findsOneWidget);
    expect(find.text('Why did you uninstall the app?'), findsOneWidget);

    // Tap Confirm Uninstall button
    final confirmBtn = find.byKey(const ValueKey('btn_confirm_uninstall'));
    expect(confirmBtn, findsOneWidget);
    await tester.tap(confirmBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Dialog appears: confirm
    expect(find.text('Are you sure?'), findsOneWidget);
    final dialogConfirmBtn = find.text('Confirm');
    await tester.tap(dialogConfirmBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify openAppSettings was triggered
    expect(mockService.didCallOpenAppSettings, isTrue);
  });
}
