import 'package:equatable/equatable.dart';

final class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}
