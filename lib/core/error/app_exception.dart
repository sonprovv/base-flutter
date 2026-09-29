import 'package:equatable/equatable.dart';

sealed class AppException extends Equatable implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

final class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause, this.fields});

  final Map<String, String>? fields;

  @override
  List<Object?> get props => [...super.props, fields];
}

final class UnknownException extends AppException {
  const UnknownException(super.message, {super.cause});
}
