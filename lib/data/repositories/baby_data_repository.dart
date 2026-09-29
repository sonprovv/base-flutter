import 'package:flutter_app_factory_base/data/models/feature_item.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/models/vip_plan.dart';
import 'package:flutter_app_factory_base/data/services/baby_data_local_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BabyDataRepository {

  BabyDataRepository(this._local);
  final BabyDataLocalService _local;

  Future<List<FeatureItem>> getHomeFunctions() => _local.getHomeFunctions();
  Future<List<CategoryItem>> getHomeRecommends() => _local.getHomeRecommends();
  Future<List<CategoryItem>> getDanceTemplates() => _local.getDanceTemplates();
  Future<List<CategoryItem>> getPhotoTemplates() => _local.getPhotoTemplates();
  Future<List<ProfileWork>> getProfileWorks() => _local.getProfileWorks();
  Future<(String, List<String>, List<VipPlan>)> getVipPlans() => _local.getVipPlans();
}

final babyDataRepositoryProvider = Provider<BabyDataRepository>((ref) {
  return BabyDataRepository(BabyDataLocalService());
});
