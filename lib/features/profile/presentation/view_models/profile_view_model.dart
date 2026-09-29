import 'dart:async';

import 'package:flutter_app_factory_base/core/result/result.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';
import 'package:flutter_app_factory_base/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_app_factory_base/features/profile/profile_dependencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, Profile>(ProfileViewModel.new);

final class ProfileViewModel extends AsyncNotifier<Profile> {
  @override
  FutureOr<Profile> build() {
    return _load(ref.watch(getProfileProvider));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _load(ref.read(getProfileProvider)),
    );
  }

  Future<Profile> _load(GetProfile getProfile) async {
    final result = await getProfile();
    return switch (result) {
      Success<Profile>(:final value) => value,
      Failure<Profile>(:final error) => throw error,
    };
  }
}
