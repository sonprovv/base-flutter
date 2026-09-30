import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_theme.dart';
import 'package:flutter_app_factory_base/core/l10n/locale_provider.dart';
import 'package:flutter_app_factory_base/core/services/shortcut_uninstall_service.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  StreamSubscription<String>? _shortcutSub;

  @override
  void initState() {
    super.initState();
    final shortcutService = ref.read(shortcutUninstallServiceProvider);
    _shortcutSub = shortcutService.onShortcutRoute.listen((route) {
      if (route == AppRoute.uninstall) {
        ref.read(appRouterProvider).go(AppRoute.uninstall);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_shortcutSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BabyGenie',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      routerConfig: router,
      locale: locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: AppL10n.localizationsDelegates,
    );
  }
}
