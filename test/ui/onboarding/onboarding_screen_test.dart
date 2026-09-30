import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/onboarding/onboarding_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('OnboardingScreen does not display Skip button', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prefsServiceProvider.overrideWithValue(PrefsService(prefs)),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: OnboardingScreen(),
        ),
      ),
    );
    await tester.pump();

    // Verify Skip text and TextButton are NOT rendered
    expect(find.text('Skip'), findsNothing);
    expect(find.byType(TextButton), findsNothing);

    // Verify Terms & Privacy Policy button is clickable
    final policyLink = find.byKey(const ValueKey('btn_onboarding_terms_policy'));
    expect(policyLink, findsOneWidget);
    await tester.tap(policyLink);
    await tester.pump();
  });
}
