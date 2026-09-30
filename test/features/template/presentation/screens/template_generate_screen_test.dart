import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_shared.dart';
import 'package:flutter_app_factory_base/features/template/presentation/screens/template_generate_screen.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Widget createTestApp({required Widget home, List<RouteBase>? extraRoutes}) {
  final router = GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(
        path: '/test',
        builder: (context, state) => home,
      ),
      GoRoute(
        path: AppRoute.photoUploadReminder,
        builder: (context, state) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => context.pop('assets/images/img_gender_baby_girl.png'),
              child: const Text('Simulate Picked Photo'),
            ),
          ),
        ),
      ),
      ...?extraRoutes,
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      locale: const Locale('en'),
    ),
  );
}

void main() {
  group('TemplateGenerateScreen Composition Tests', () {
    testWidgets('baby_only: Born Baby has only baby component', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      const template = TemplateItem(
        id: '1',
        name: 'Baby Only Template',
        composition: 'baby_only',
      );
      await tester.pumpWidget(createTestApp(home: const TemplateGenerateScreen(template: template)));
      await tester.pumpAndSettle();

      expect(find.text("Baby's Photo"), findsOneWidget);
      expect(find.text("Mom's Photo"), findsNothing);
      expect(find.text("Dad's Photo"), findsNothing);
      expect(find.text('Upload Photo'), findsOneWidget);
    });

    testWidgets('baby_family: Born Baby has mom, dad and baby with CurveArrow (Future Family UI)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      const template = TemplateItem(
        id: '2',
        name: 'Baby Family Template',
        composition: 'baby_family',
      );
      await tester.pumpWidget(createTestApp(home: const TemplateGenerateScreen(template: template)));
      await tester.pumpAndSettle();

      expect(find.text("Mom's Photo"), findsOneWidget);
      expect(find.text("Dad's Photo"), findsOneWidget);
      expect(find.byType(CurveArrow), findsOneWidget);
      expect(find.text("Baby's Photo"), findsOneWidget);
      expect(find.text('Upload Photo'), findsNWidgets(3));
    });

    testWidgets('baby_with_mom: Born Baby has mom and baby components; Unborn has only mom', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      const template = TemplateItem(
        id: '3',
        name: 'Baby With Mom Template',
        composition: 'baby_with_mom',
      );
      await tester.pumpWidget(createTestApp(home: const TemplateGenerateScreen(template: template)));
      await tester.pumpAndSettle();

      // Born Baby tab
      expect(find.text("Mom's Photo"), findsOneWidget);
      expect(find.text("Baby's Photo"), findsOneWidget);
      expect(find.text("Dad's Photo"), findsNothing);
      expect(find.text('Upload Photo'), findsNWidgets(2));

      // Switch to Unborn Baby tab
      await tester.tap(find.text('Unborn Baby'));
      await tester.pumpAndSettle();

      expect(find.text("Mom's Photo"), findsOneWidget);
      expect(find.text("Dad's Photo"), findsNothing);
      expect(find.text("Baby's Photo"), findsNothing);
      expect(find.text('Upload Photo'), findsOneWidget);
    });

    testWidgets('baby_with_dad: Born Baby has dad and baby components; Unborn has only dad', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      const template = TemplateItem(
        id: '4',
        name: 'Baby With Dad Template',
        composition: 'baby_with_dad',
      );
      await tester.pumpWidget(createTestApp(home: const TemplateGenerateScreen(template: template)));
      await tester.pumpAndSettle();

      // Born Baby tab
      expect(find.text("Dad's Photo"), findsOneWidget);
      expect(find.text("Baby's Photo"), findsOneWidget);
      expect(find.text("Mom's Photo"), findsNothing);
      expect(find.text('Upload Photo'), findsNWidgets(2));

      // Switch to Unborn Baby tab
      await tester.tap(find.text('Unborn Baby'));
      await tester.pumpAndSettle();

      expect(find.text("Dad's Photo"), findsOneWidget);
      expect(find.text("Mom's Photo"), findsNothing);
      expect(find.text("Baby's Photo"), findsNothing);
      expect(find.text('Upload Photo'), findsOneWidget);
    });

    testWidgets('empty composition: auto triggers photoUploadReminder', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      const template = TemplateItem(
        id: '5',
        name: 'Dance Template',
        composition: '',
      );
      await tester.pumpWidget(createTestApp(home: const TemplateGenerateScreen(template: template)));
      await tester.pump();
      await tester.pumpAndSettle();

      // Verified it navigated to simulate photo upload reminder
      expect(find.text('Simulate Picked Photo'), findsOneWidget);
    });
  });
}
