import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/app.dart';
import 'package:flutter_app_factory_base/core/config/app_config.dart';
import 'package:flutter_app_factory_base/core/config/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  await runZonedGuarded(
    () async {
      runApp(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(config)],
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
