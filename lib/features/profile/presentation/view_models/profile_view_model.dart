import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WorkFilter { all, video, photo }

class ProfileState {

  const ProfileState({
    this.works = const [],
    this.filter = WorkFilter.all,
    this.isLoading = false,
  });
  final List<ProfileWork> works;
  final WorkFilter filter;
  final bool isLoading;

  List<ProfileWork> get filtered => switch (filter) {
        WorkFilter.all => works,
        WorkFilter.video => works.where((w) => w.isVideo).toList(),
        WorkFilter.photo => works.where((w) => !w.isVideo).toList(),
      };

  ProfileState copyWith({
    List<ProfileWork>? works,
    WorkFilter? filter,
    bool? isLoading,
  }) {
    return ProfileState(
      works: works ?? this.works,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileViewModel extends AsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() async {
    final repo = ref.read(babyDataRepositoryProvider);
    final works = await repo.getProfileWorks();
    return ProfileState(works: works);
  }

  void setFilter(WorkFilter filter) {
    final current = state.asData?.value;
    if (current != null) {
      state = AsyncData(current.copyWith(filter: filter));
    }
  }
}

final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);
