import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/screens/family_similarity_screen.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/screens/future_baby_screen.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/screens/future_family_screen.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/screens/ultrasound_viewer_screen.dart';
import 'package:flutter_app_factory_base/features/paywall/presentation/screens/paywall_screen.dart';
import 'package:flutter_app_factory_base/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_app_factory_base/features/template/presentation/screens/dance_detail_screen.dart';
import 'package:flutter_app_factory_base/features/template/presentation/screens/photo_detail_screen.dart';
import 'package:flutter_app_factory_base/features/template/presentation/screens/template_generate_screen.dart';
import 'package:flutter_app_factory_base/features/template/presentation/screens/template_list_screen.dart';
import 'package:flutter_app_factory_base/ui/language/language_screen.dart';
import 'package:flutter_app_factory_base/ui/main/main_screen.dart';
import 'package:flutter_app_factory_base/ui/onboarding/onboarding_screen.dart';
import 'package:flutter_app_factory_base/ui/splash/splash_screen.dart';
import 'package:flutter_app_factory_base/ui/uninstall/ask_uninstall_screen.dart';
import 'package:flutter_app_factory_base/ui/uninstall/uninstall_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoute {
  static const splash = '/';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const main = '/main';
  static const paywall = '/paywall';
  static const futureBaby = '/generate/future-baby';
  static const futureFamily = '/generate/future-family';
  static const familySimilarity = '/generate/family-similarity';
  static const ultrasound = '/generate/ultrasound';
  static const templateList = '/template/list';
  static const danceDetail = '/template/dance-detail';
  static const photoDetail = '/template/photo-detail';
  static const templateGenerate = '/template/generate';
  static const settings = '/settings';
  static const uninstall = '/uninstall';
  static const askUninstall = '/uninstall/ask';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoute.splash,
    routes: [
      GoRoute(
        path: AppRoute.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.language,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: AppRoute.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoute.main,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoute.paywall,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: AppRoute.futureBaby,
        builder: (context, state) => const FutureBabyScreen(),
      ),
      GoRoute(
        path: AppRoute.futureFamily,
        builder: (context, state) => const FutureFamilyScreen(),
      ),
      GoRoute(
        path: AppRoute.familySimilarity,
        builder: (context, state) => const FamilySimilarityScreen(),
      ),
      GoRoute(
        path: AppRoute.ultrasound,
        builder: (context, state) => const UltrasoundViewerScreen(),
      ),
      GoRoute(
        path: AppRoute.templateList,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final category = extra?['category'] as String? ?? '';
          return TemplateListScreen(category: category);
        },
      ),
      GoRoute(
        path: AppRoute.danceDetail,
        builder: (context, state) {
          final template = state.extra as TemplateItem;
          return DanceDetailScreen(template: template);
        },
      ),
      GoRoute(
        path: AppRoute.photoDetail,
        builder: (context, state) {
          final template = state.extra as TemplateItem;
          return PhotoDetailScreen(template: template);
        },
      ),
      GoRoute(
        path: AppRoute.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoute.templateGenerate,
        builder: (context, state) {
          final template = state.extra as TemplateItem?;
          return TemplateGenerateScreen(template: template);
        },
      ),
      GoRoute(
        path: AppRoute.uninstall,
        builder: (context, state) => const UninstallScreen(),
      ),
      GoRoute(
        path: AppRoute.askUninstall,
        builder: (context, state) => const AskUninstallScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
