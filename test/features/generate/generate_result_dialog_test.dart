import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_result_dialog.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestApp(Widget home) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: home),
    ),
  );
}

void main() {
  group('GenerateResultDialog Widget Tests', () {
    testWidgets('shows loading phase initially with indicator and localized messages', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      await tester.pumpWidget(
        createTestApp(
          const GenerateResultDialog(
            featureTitle: 'Future Baby',
            resultAsset: 'assets/images/img_gender_baby_girl.png',
          ),
        ),
      );

      // Verify Loading Phase components
      expect(find.byKey(const ValueKey('loading_view')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('Generating AI Baby...'), findsOneWidget);
      expect(find.text('Analyzing facial features and generating result'), findsOneWidget);
    });

    testWidgets('transitions to preview output with Save and Not now buttons after loading completes', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      await tester.pumpWidget(
        createTestApp(
          const GenerateResultDialog(
            featureTitle: 'Future Baby',
            resultAsset: 'assets/images/img_gender_baby_girl.png',
          ),
        ),
      );

      // Advance time for simulated generation (~2.1 seconds)
      await tester.pump(const Duration(milliseconds: 2200));
      await tester.pumpAndSettle();

      // Verify Preview Phase components
      expect(find.byKey(const ValueKey('preview_view')), findsOneWidget);
      expect(find.text('Future Baby'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Not now'), findsOneWidget);
      expect(find.byIcon(Icons.download_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}
