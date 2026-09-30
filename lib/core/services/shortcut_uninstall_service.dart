import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service managing the Android Home Screen / Launcher "Uninstall" shortcut,
/// detecting launches routed from the shortcut, and triggering package uninstallation.
class ShortcutUninstallService {
  ShortcutUninstallService({MethodChannel? channel})
      : _channel = channel ??
            const MethodChannel(
              'com.example.flutter_app_factory_base/shortcut_uninstall',
            ) {
    _channel.setMethodCallHandler(_handleNativeMethodCall);
  }

  final MethodChannel _channel;
  final StreamController<String> _shortcutRouteController =
      StreamController<String>.broadcast();

  /// Stream of route requests incoming from native shortcuts (e.g., onNewIntent).
  Stream<String> get onShortcutRoute => _shortcutRouteController.stream;

  Future<dynamic> _handleNativeMethodCall(MethodCall call) async {
    if (call.method == 'onShortcutRoute') {
      final route = call.arguments as String?;
      if (route != null && route.isNotEmpty) {
        _shortcutRouteController.add(route);
      }
    }
  }

  /// Checks if the app was launched via a shortcut targeting a specific route (e.g. '/uninstall').
  Future<String?> getInitialRoute() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }
    try {
      final route = await _channel.invokeMethod<String>('getInitialRoute');
      return route;
    } on PlatformException catch (e) {
      debugPrint('ShortcutUninstallService.getInitialRoute error: $e');
      return null;
    } catch (e) {
      debugPrint('ShortcutUninstallService.getInitialRoute unexpected error: $e');
      return null;
    }
  }

  /// Requests pinning/publishing the "Uninstall" shortcut on Android launcher/home screen.
  Future<bool> createUninstallShortcut() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    try {
      final success =
          await _channel.invokeMethod<bool>('createUninstallShortcut');
      return success ?? false;
    } on PlatformException catch (e) {
      debugPrint('ShortcutUninstallService.createUninstallShortcut error: $e');
      return false;
    } catch (e) {
      debugPrint('ShortcutUninstallService.createUninstallShortcut unexpected error: $e');
      return false;
    }
  }

  /// Opens the device App Settings (App Info) screen for this app so the user can uninstall or manage permissions.
  Future<bool> openAppSettings() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    try {
      final success = await _channel.invokeMethod<bool>('openAppSettings');
      return success ?? false;
    } on PlatformException catch (e) {
      debugPrint('ShortcutUninstallService.openAppSettings error: $e');
      return false;
    } catch (e) {
      debugPrint('ShortcutUninstallService.openAppSettings unexpected error: $e');
      return false;
    }
  }

  /// Triggers the uninstallation flow by opening the App Info / Settings screen where the user can tap "Uninstall".
  Future<bool> uninstallApp() async {
    return openAppSettings();
  }

  void dispose() {
    unawaited(_shortcutRouteController.close());
  }
}

/// Global provider for [ShortcutUninstallService].
final shortcutUninstallServiceProvider =
    Provider<ShortcutUninstallService>((ref) {
  final service = ShortcutUninstallService();
  ref.onDispose(service.dispose);
  return service;
});
