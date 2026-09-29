import 'package:flutter_app_factory_base/core/result/result.dart';
import 'package:flutter_app_factory_base/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:flutter_app_factory_base/features/profile/data/models/profile_dto.dart';
import 'package:flutter_app_factory_base/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

void main() {
  late _MockProfileRemoteDataSource remote;
  late ProfileRepositoryImpl repository;

  setUp(() {
    remote = _MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(remote);
  });

  test('maps DTO to domain entity', () async {
    when(remote.getProfile).thenAnswer(
      (_) async => const ProfileDto(
        id: 1,
        name: 'Ada Lovelace',
        email: 'ada@example.com',
      ),
    );

    final result = await repository.getProfile();

    expect(result, isA<Success<Profile>>());
    final profile = (result as Success<Profile>).value;
    expect(profile.name, 'Ada Lovelace');
  });
}
