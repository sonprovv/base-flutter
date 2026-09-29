import 'package:dio/dio.dart';
import 'package:flutter_app_factory_base/core/config/app_config.dart';
import 'package:flutter_app_factory_base/core/config/providers.dart';
import 'package:flutter_app_factory_base/core/error/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
    ),
  );

  if (config.enableNetworkLogs && !config.isProduction) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  return dio;
});

AppException mapDioException(DioException error) {
  final statusCode = error.response?.statusCode;

  if (statusCode == 401 || statusCode == 403) {
    return const UnauthorizedException();
  }
  if (statusCode == 404) {
    return const NotFoundException();
  }
  if (statusCode != null && statusCode >= 400 && statusCode < 500) {
    return ValidationException(
      'Request rejected with status $statusCode',
      cause: error,
    );
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkException('Network connection failed', cause: error);
    case DioExceptionType.badCertificate:
      return NetworkException('TLS certificate validation failed', cause: error);
    case DioExceptionType.cancel:
      return NetworkException('Request was cancelled', cause: error);
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      return UnknownException('Unexpected network error', cause: error);
  }
}
