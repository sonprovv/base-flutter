import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBabyDataRepository implements BabyDataRepository {
  @override
  Future<List<ProfileWork>> getProfileWorks() async => [];

  @override
  Future<void> addProfileWork(ProfileWork work) async {}

  @override
  Future<void> removeProfileWork(int id) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget createTestApp(Widget home) {
  return ProviderScope(
    overrides: [
      babyDataRepositoryProvider.overrideWithValue(_FakeBabyDataRepository()),
    ],
    child: MaterialApp(
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      locale: const Locale('en'),
      home: home,
    ),
  );
}

void main() {
  group('ProfileScreen Asset & UI Verification', () {
    testWidgets('renders setting icon, mine baby avatar, and VIP banner', (tester) async {
      await tester.binding.setSurfaceSize(const Size(412, 915));

      await tester.pumpWidget(createTestApp(const ProfileScreen()));
      await tester.pumpAndSettle();

      // Check header title and ic_profile_setting asset
      expect(find.text('Profile'), findsOneWidget);
      final settingFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/ic_profile_setting.png',
      );
      expect(settingFinder, findsOneWidget);

      // Check user avatar uses ic_profile_mine_setting asset
      final avatarFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/ic_profile_mine_setting.png',
      );
      expect(avatarFinder, findsOneWidget);

      // Check VIP Pro banner components
      expect(find.text('BabyGenie VIP'), findsOneWidget);
      expect(find.text('Get VIP'), findsOneWidget);
      final kingFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/images/ic_profile_king.png',
      );
      expect(kingFinder, findsOneWidget);

      // Check Filter chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
      expect(find.text('Photo'), findsOneWidget);
    });
  });
}
