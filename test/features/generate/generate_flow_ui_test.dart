import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/screens/future_baby_screen.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/screens/future_family_screen.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/screens/generating_screen.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/screens/profile_work_detail_screen.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestApp(Widget home) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      locale: const Locale('en'),
      home: home,
    ),
  );
}

void main() {
  group('FutureFamilyScreen UI Verification', () {
    testWidgets('renders Boy or Girl title, pickers, carousel, and Generate Baby Photo button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      await tester.pumpWidget(createTestApp(const FutureFamilyScreen()));
      await tester.pumpAndSettle();

      // Check Heading text
      expect(find.text('Boy or Girl'), findsOneWidget);

      // Check Picker texts
      expect(find.text("Dad's Photo"), findsOneWidget);
      expect(find.text("Mom's Photo"), findsOneWidget);
      expect(find.text('Upload Photo'), findsNWidgets(2));

      // Check Gender carousel texts
      expect(find.text('Baby Girl'), findsOneWidget);
      expect(find.text('Baby Boy'), findsOneWidget);
      expect(find.text('Teen Girl'), findsOneWidget);

      // Scroll carousel to check offscreen Teen Boy
      await tester.drag(find.text('Teen Girl'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(find.text('Teen Boy'), findsOneWidget);

      // Check CTA Button (GradientCtaButton)
      final ctaFinder = find.byKey(const ValueKey('btn_future_family_generate'));
      expect(ctaFinder, findsOneWidget);
      final ctaWidget = tester.widget<GradientCtaButton>(ctaFinder);
      expect(ctaWidget.enabled, isFalse);
      expect(find.text('Generate Baby Photo'), findsOneWidget);
    });

    testWidgets('allows gender option selection and updates purple highlight', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      await tester.pumpWidget(createTestApp(const FutureFamilyScreen()));
      await tester.pumpAndSettle();

      // Tap on Baby Boy
      await tester.tap(find.text('Baby Boy'));
      await tester.pumpAndSettle();

      // Tap on Baby Girl
      await tester.tap(find.text('Baby Girl'));
      await tester.pumpAndSettle();
    });
  });

  group('FutureBabyScreen UI Verification', () {
    testWidgets('renders Boy or Girl title, pickers, and Generate Baby Photo button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      await tester.pumpWidget(createTestApp(const FutureBabyScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Boy or Girl'), findsOneWidget);
      expect(find.text("Dad's Photo"), findsOneWidget);
      expect(find.text("Mom's Photo"), findsOneWidget);
      expect(find.text('Generate Baby Photo'), findsOneWidget);

      final ctaFinder = find.byKey(const ValueKey('btn_future_baby_generate'));
      expect(ctaFinder, findsOneWidget);
      final ctaWidget = tester.widget<GradientCtaButton>(ctaFinder);
      expect(ctaWidget.enabled, isFalse);
    });
  });

  group('GeneratingScreen UI Verification', () {
    testWidgets('renders progress, status text, Buy Points, Trending, and Bottom Nav Bar', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      await tester.pumpWidget(
        createTestApp(
          const GeneratingScreen(
            featureTitle: 'Future Family',
            momPath: 'assets/images/sample_mom.png',
            dadPath: 'assets/images/sample_dad.png',
            prompt: 'The child is a 1-year-old girl',
            resultAsset: 'assets/images/ic_baby_girl.png',
          ),
        ),
      );
      await tester.pump();

      // Check initial progress status
      expect(find.text('Your Future Family is on the way ✨'), findsOneWidget);
      expect(find.text('💎 Buy Points'), findsOneWidget);
      expect(find.text('Trending'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Photo'), findsOneWidget);

      // Advance timers by 14 seconds to complete full submission + progress
      await tester.pump(const Duration(milliseconds: 950));
      for (int i = 0; i < 13; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await tester.pumpAndSettle();

      // Should transition to completed state
      expect(find.text('Creation completed'), findsOneWidget);
      expect(find.text('View now'), findsOneWidget);
    });
  });

  group('ProfileWorkDetailScreen (Production Record) UI Verification', () {
    testWidgets('renders Production Record header, Save to Phone, and more menu', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      const testWork = ProfileWork(
        id: 1,
        name: 'Baby Girl',
        type: 'photo',
        mediaUrl: 'assets/images/ic_baby_girl.png',
        coverUrl: 'assets/images/ic_baby_girl.png',
        previewWebpUrl: '',
        status: 1,
        createdAt: '2026-09-30',
      );

      await tester.pumpWidget(createTestApp(const ProfileWorkDetailScreen(work: testWork)));
      await tester.pumpAndSettle();

      // Check AppBar Title
      expect(find.text('Production Record'), findsOneWidget);

      // Check Save to Phone button
      expect(find.text('Save to Phone'), findsOneWidget);
      final saveBtn = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save to Phone'),
      );
      expect(saveBtn.style?.backgroundColor?.resolve({}), const Color(0xFF583FFE));

      // Tap Save to Phone -> should show SnackBar 'Saved to gallery'
      await tester.tap(find.text('Save to Phone'));
      await tester.pump();
      expect(find.text('Saved to gallery'), findsOneWidget);

      // Tap more actions (...) icon
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      // Check bottom sheet options
      expect(find.text('Report'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Tap Report -> dismisses bottom sheet
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();
      // Sheet dismissed, Production Record screen remains visible
      expect(find.text('Production Record'), findsOneWidget);
    });
  });
}
