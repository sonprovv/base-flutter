import 'package:flutter_app_factory_base/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoute {
  static const home = '/';
  static const profile = '/profile';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoute.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
