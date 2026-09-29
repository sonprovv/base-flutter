import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class Tracker {
  Future<void> event(String name, [Map<String, Object?> parameters = const {}]);
  Future<void> screen(String name);
}

final class NoopTracker implements Tracker {
  const NoopTracker();

  @override
  Future<void> event(
    String name, [
    Map<String, Object?> parameters = const {},
  ]) async {}

  @override
  Future<void> screen(String name) async {}
}

final trackerProvider = Provider<Tracker>((ref) => const NoopTracker());
