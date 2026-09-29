import 'package:dio/dio.dart';
import 'package:flutter_app_factory_base/core/utils/typedefs.dart';
import 'package:flutter_app_factory_base/features/profile/data/models/profile_dto.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileDto> getProfile();
}

final class DioProfileRemoteDataSource implements ProfileRemoteDataSource {
  const DioProfileRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<ProfileDto> getProfile() async {
    final response = await _dio.get<JsonMap>('/users/1');
    final data = response.data;
    if (data == null) {
      throw StateError('Profile API returned an empty response.');
    }
    return ProfileDto.fromJson(data);
  }
}
