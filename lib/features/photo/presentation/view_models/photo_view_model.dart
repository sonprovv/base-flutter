import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final photoViewModelProvider = FutureProvider<List<CategoryItem>>((ref) async {
  final repo = ref.read(babyDataRepositoryProvider);
  return repo.getPhotoTemplates();
});
