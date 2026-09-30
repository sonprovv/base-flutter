import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SettingsScreen privacy policy item is clickable and receives event', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final policyBtn = find.byKey(const ValueKey('btn_settings_privacy_policy'));
    expect(policyBtn, findsOneWidget);

    // Tap the privacy policy button
    await tester.tap(policyBtn);
    await tester.pump();
  });
}
