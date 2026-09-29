import 'package:flutter_app_factory_base/core/error/app_exception.dart';
import 'package:flutter_app_factory_base/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('fold returns success branch', () {
      const result = Success<int>(42);

      final value = result.fold(
        onSuccess: (data) => 'ok:$data',
        onFailure: (error) => 'error:${error.message}',
      );

      expect(value, 'ok:42');
    });

    test('fold returns failure branch', () {
      const result = Failure<int>(NetworkException('offline'));

      final value = result.fold(
        onSuccess: (data) => 'ok:$data',
        onFailure: (error) => 'error:${error.message}',
      );

      expect(value, 'error:offline');
    });
  });
}
