import 'package:flutter_app_factory_base/data/models/feature_item.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {

  const HomeState({
    this.features = const [],
    this.categories = const [],
    this.isLoading = false,
  });
  final List<FeatureItem> features;
  final List<CategoryItem> categories;
  final bool isLoading;

  HomeState copyWith({
    List<FeatureItem>? features,
    List<CategoryItem>? categories,
    bool? isLoading,
  }) {
    return HomeState(
      features: features ?? this.features,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    return _load();
  }

  Future<HomeState> _load() async {
    final repo = ref.read(babyDataRepositoryProvider);
    final results = await Future.wait([
      repo.getHomeFunctions(),
      repo.getHomeRecommends(),
    ]);
    return HomeState(
      features: results[0] as List<FeatureItem>,
      categories: results[1] as List<CategoryItem>,
    );
  }
}

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);
