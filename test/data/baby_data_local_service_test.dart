import 'package:flutter_app_factory_base/data/services/baby_data_local_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('BabyDataLocalService loads all mock data without throwing', () async {
    final service = BabyDataLocalService();

    final functions = await service.getHomeFunctions();
    expect(functions, isNotEmpty);

    final recommends = await service.getHomeRecommends();
    expect(recommends, isNotEmpty);
    expect(recommends.first.templates, isNotEmpty);

    final dance = await service.getDanceTemplates();
    expect(dance, isNotEmpty);

    final photo = await service.getPhotoTemplates();
    expect(photo, isNotEmpty);

    final profile = await service.getProfileWorks();
    expect(profile, isNotEmpty);

    final (headline, benefits, plans) = await service.getVipPlans();
    expect(headline, isNotEmpty);
    expect(plans, isNotEmpty);
  });
}
