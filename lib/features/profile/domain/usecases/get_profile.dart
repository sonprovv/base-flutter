import 'package:flutter_app_factory_base/core/result/result.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';
import 'package:flutter_app_factory_base/features/profile/domain/repositories/profile_repository.dart';

final class GetProfile {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<Profile>> call() => _repository.getProfile();
}
