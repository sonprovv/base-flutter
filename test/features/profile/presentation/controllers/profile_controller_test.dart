import 'package:flutter_app_factory_base/core/result/result.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';
import 'package:flutter_app_factory_base/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_app_factory_base/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  test('controller exposes profile from use case', () async {
    final repository = _MockProfileRepository();
    const expected = Profile(
      id: 1,
      name: 'Ada Lovelace',
      email: 'ada@example.com',
    );

    when(repository.getProfile).thenAnswer((_) async => const Success(expected));

    final container = ProviderContainer(
      overrides: [
        getProfileProvider.overrideWithValue(GetProfile(repository)),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(profileControllerProvider.future);
    expect(value, expected);
  });
}
