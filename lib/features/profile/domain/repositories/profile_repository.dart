import 'package:flutter_app_factory_base/core/result/result.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Result<Profile>> getProfile();
}
