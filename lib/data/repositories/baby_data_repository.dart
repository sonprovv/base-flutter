import 'package:flutter_app_factory_base/data/local/profile_work_dao.dart';
import 'package:flutter_app_factory_base/data/models/feature_item.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/models/vip_plan.dart';
import 'package:flutter_app_factory_base/data/services/baby_data_local_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BabyDataRepository {

  BabyDataRepository(this._local, this._profileWorkDao);
  final BabyDataLocalService _local;
  final ProfileWorkDao _profileWorkDao;

  Future<List<FeatureItem>> getHomeFunctions() => _local.getHomeFunctions();
  Future<List<CategoryItem>> getHomeRecommends() => _local.getHomeRecommends();
  Future<List<CategoryItem>> getDanceTemplates() => _local.getDanceTemplates();
  Future<List<CategoryItem>> getPhotoTemplates() => _local.getPhotoTemplates();
  Future<List<ProfileWork>> getProfileWorks() => _profileWorkDao.getAll();
  Future<void> addProfileWork(ProfileWork work) => _profileWorkDao.add(work);
  Future<void> updateProfileWork(ProfileWork work) => _profileWorkDao.update(work);
  Future<void> removeProfileWork(int id) => _profileWorkDao.remove(id);
  Future<(String, List<String>, List<VipPlan>)> getVipPlans() => _local.getVipPlans();
}

final babyDataRepositoryProvider = Provider<BabyDataRepository>((ref) {
  return BabyDataRepository(BabyDataLocalService(), ref.read(profileWorkDaoProvider));
});
