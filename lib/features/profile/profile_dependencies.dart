import 'package:flutter_app_factory_base/core/network/dio_client.dart';
import 'package:flutter_app_factory_base/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flutter_app_factory_base/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_app_factory_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_app_factory_base/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return DioProfileRemoteDataSource(ref.watch(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
});

final getProfileProvider = Provider<GetProfile>((ref) {
  return GetProfile(ref.watch(profileRepositoryProvider));
});
