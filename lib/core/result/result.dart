import 'package:flutter_app_factory_base/core/error/app_exception.dart';

sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppException error) onFailure,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Failure<T>(:final error) => onFailure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AppException error;
}
