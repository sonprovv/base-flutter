import 'package:flutter_app_factory_base/core/utils/typedefs.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';

final class ProfileDto {
  const ProfileDto({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ProfileDto.fromJson(JsonMap json) {
    return ProfileDto(
      id: json['id']! as int,
      name: json['name']! as String,
      email: json['email']! as String,
    );
  }

  final int id;
  final String name;
  final String email;

  Profile toDomain() => Profile(id: id, name: name, email: email);
}
