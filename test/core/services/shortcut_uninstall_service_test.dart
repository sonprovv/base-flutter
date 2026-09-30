import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_factory_base/core/services/shortcut_uninstall_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannel channel;
  late ShortcutUninstallService service;
  final log = <MethodCall>[];

  setUp(() {
    log.clear();
    channel = const MethodChannel(
      'com.example.flutter_app_factory_base/shortcut_uninstall',
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getInitialRoute':
          return '/uninstall';
        case 'createUninstallShortcut':
          return true;
        case 'openAppSettings':
        case 'uninstallApp':
          return true;
        default:
          return null;
      }
    });

    service = ShortcutUninstallService(channel: channel);
  });

  tearDown(() {
    service.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('ShortcutUninstallService - Non-Android fallback', () {
    test('getInitialRoute returns null on non-Android platforms', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final route = await service.getInitialRoute();
      expect(route, isNull);
      expect(log, isEmpty);
      debugDefaultTargetPlatformOverride = null;
    });

    test('createUninstallShortcut returns false on non-Android platforms', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final result = await service.createUninstallShortcut();
      expect(result, isFalse);
      expect(log, isEmpty);
      debugDefaultTargetPlatformOverride = null;
    });

    test('openAppSettings returns false on non-Android platforms', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final result = await service.openAppSettings();
      expect(result, isFalse);
      expect(log, isEmpty);
      debugDefaultTargetPlatformOverride = null;
    });

    test('uninstallApp returns false on non-Android platforms', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final result = await service.uninstallApp();
      expect(result, isFalse);
      expect(log, isEmpty);
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('ShortcutUninstallService - Android platform', () {
    test('getInitialRoute invokes native method and returns route', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final route = await service.getInitialRoute();
      expect(route, equals('/uninstall'));
      expect(log.any((call) => call.method == 'getInitialRoute'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('createUninstallShortcut invokes native method and returns true', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final result = await service.createUninstallShortcut();
      expect(result, isTrue);
      expect(log.any((call) => call.method == 'createUninstallShortcut'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('openAppSettings invokes native method and returns true', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final result = await service.openAppSettings();
      expect(result, isTrue);
      expect(log.any((call) => call.method == 'openAppSettings'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('uninstallApp invokes openAppSettings and returns true', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final result = await service.uninstallApp();
      expect(result, isTrue);
      expect(log.any((call) => call.method == 'openAppSettings'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('listens to onShortcutRoute native call', () async {
      String? receivedRoute;
      final sub = service.onShortcutRoute.listen((route) {
        receivedRoute = route;
      });

      final binaryMessenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      final codec = channel.codec;
      final data = codec.encodeMethodCall(
        const MethodCall('onShortcutRoute', '/uninstall'),
      );
      await binaryMessenger.handlePlatformMessage(
        channel.name,
        data,
        (ByteData? reply) {},
      );

      await pumpEventQueue();
      expect(receivedRoute, equals('/uninstall'));
      await sub.cancel();
    });
  });
}
