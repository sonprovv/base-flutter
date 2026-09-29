import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockBabyDataRepository extends Mock implements BabyDataRepository {}

void main() {
  test('profile view model loads profile works', () async {
    final repository = _MockBabyDataRepository();
    final expectedWorks = [
      const ProfileWork(
        id: 1,
        name: 'Work 1',
        type: 'photo',
      ),
    ];

    when(repository.getProfileWorks).thenAnswer((_) async => expectedWorks);

    final container = ProviderContainer(
      overrides: [
        babyDataRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final state = await container.read(profileViewModelProvider.future);
    expect(state.works, expectedWorks);
  });
}
