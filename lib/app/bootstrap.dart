import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/app.dart';
import 'package:flutter_app_factory_base/core/config/app_config.dart';
import 'package:flutter_app_factory_base/core/config/providers.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_app_factory_base/data/services/baby_data_local_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stack),
    );
    return true;
  };

  final prefs = await SharedPreferences.getInstance();
  final prefsService = PrefsService(prefs);

  // Preload heavy JSON assets in parallel while prefs finishes.
  await BabyDataLocalService.preload([
    'assets/data/home_functions.json',
    'assets/data/home_recommends.json',
  ]);
  // Kick off image downloads immediately after JSON parse — fire-and-forget.
  BabyDataLocalService.warmImageCache();

  await runZonedGuarded(
    () async {
      runApp(
        ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(config),
            prefsServiceProvider.overrideWithValue(prefsService),
          ],
          child: const App(),
        ),
      );
    },
    (error, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stack),
      );
    },
  );
}
