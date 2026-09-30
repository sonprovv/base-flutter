import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/language/language_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('LanguageScreen hides back button when isFirstOpenApp is true', (tester) async {
    SharedPreferences.setMockInitialValues({
      'open_count': 1,
      'completed_onboarding': false,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prefsServiceProvider.overrideWithValue(PrefsService(prefs)),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: LanguageScreen(isFirstOpenApp: true),
        ),
      ),
    );
    await tester.pump();

    // Verify back button is NOT present
    expect(find.byType(IconButton), findsNothing);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });

  testWidgets('LanguageScreen shows back button when isFirstOpenApp is false and canPop is true', (tester) async {
    SharedPreferences.setMockInitialValues({
      'open_count': 2,
      'completed_onboarding': true,
    });
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prefsServiceProvider.overrideWithValue(PrefsService(prefs)),
        ],
        child: MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LanguageScreen(isFirstOpenApp: false),
                      ),
                    );
                  },
                  child: const Text('Open Language'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // Navigate to LanguageScreen
    await tester.tap(find.text('Open Language'));
    await tester.pumpAndSettle();

    // Verify back button is present
    expect(find.byType(IconButton), findsOneWidget);

    // Tap back button
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // Verify popped back
    expect(find.text('Open Language'), findsOneWidget);
  });
}
