import 'package:dio/dio.dart';
import 'package:flutter_app_factory_base/core/error/app_exception.dart';
import 'package:flutter_app_factory_base/core/network/dio_client.dart';
import 'package:flutter_app_factory_base/core/result/result.dart';
import 'package:flutter_app_factory_base/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';
import 'package:flutter_app_factory_base/features/profile/domain/repositories/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Profile>> getProfile() async {
    try {
      final dto = await _remoteDataSource.getProfile();
      return Success(dto.toDomain());
    } on DioException catch (error) {
      return Failure(mapDioException(error));
    } on AppException catch (error) {
      return Failure(error);
    } catch (error) {
      return Failure(
        UnknownException('Unable to load profile', cause: error),
      );
    }
  }
}
