// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppL10nZh extends AppL10n {
  AppL10nZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => '创造宝宝的神奇时刻';

  @override
  String get splashAdDisclaimer => '此操作可能包含广告';

  @override
  String get chooseLanguage => '选择语言';

  @override
  String get save => '保存';

  @override
  String get onboarding1Title => '探索你的\n未来宝宝';

  @override
  String get onboarding1Desc => '通过AI人脸生成技术，预览宝宝未来的模样';

  @override
  String get onboarding2Title => '宝宝舞蹈\n模板';

  @override
  String get onboarding2Desc => '使用热门模板，为宝宝制作可爱的舞蹈视频';

  @override
  String get onboarding3Title => '家庭\n相似度';

  @override
  String get onboarding3Desc => '通过相似度检测，发现宝宝最像谁';

  @override
  String get next => '下一步';

  @override
  String get getStarted => '开始使用';

  @override
  String get termsAgreement => '继续即表示您同意我们的条款和隐私政策';

  @override
  String get navHome => '首页';

  @override
  String get navVideo => '视频';

  @override
  String get navPhoto => '照片';

  @override
  String get navProfile => '我的';

  @override
  String get retry => '重试';

  @override
  String get comingSoon => '即将推出！';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get error => '错误';

  @override
  String get homeLoadError => '首页加载失败';

  @override
  String get profileTitle => '我的';

  @override
  String get profileUser => 'BabyGenie 用户';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString 个作品';
  }

  @override
  String get filterAll => '全部';

  @override
  String get noCreationsYet => '暂无作品';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsPrivacyPolicy => '隐私政策';

  @override
  String get settingsRateApp => '评价应用';

  @override
  String get settingsShareApp => '分享应用';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => '妈妈的照片';

  @override
  String get dadsPhoto => '爸爸的照片';

  @override
  String get babysPhoto => '宝宝照片';

  @override
  String get boyOrGirl => '男宝还是女宝';

  @override
  String get uploadPhotoHint => '请上传清晰的正面照片以获得最佳效果';

  @override
  String get generateBabyPhoto => '生成宝宝照片';

  @override
  String get uploadPhoto => '上传照片';

  @override
  String get tapToSelectImage => '点击选择图片';

  @override
  String get babyGirl => '女婴';

  @override
  String get babyBoy => '男婴';

  @override
  String get teenGirl => '少女';

  @override
  String get teenBoy => '少年';

  @override
  String get noTemplatesFound => '未找到模板';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => '解锁所有高级功能';

  @override
  String get paywallTrial => '试用';

  @override
  String get paywallContinue => '继续';

  @override
  String get paywallCancelNote => '随时取消 · 恢复购买';

  @override
  String get uninstallSorry => '若未能满足您的期望，我们深表歉意。';

  @override
  String get uninstallImprove => '请告诉我们如何改进。';

  @override
  String get uninstallNotUseful => '不比默认功能实用';

  @override
  String get uninstallLaggy => '响应慢或无响应';

  @override
  String get explore => '探索';

  @override
  String get dontUninstall => '暂不卸载';

  @override
  String get stillUninstall => '仍要卸载';

  @override
  String get whyUninstall => '您为什么要卸载应用？';

  @override
  String get uninstall => '卸载';

  @override
  String get uninstallReasonDifficult => '难以使用';

  @override
  String get uninstallReasonAds => '广告太多';

  @override
  String get uninstallReasonError => '出错无法使用';

  @override
  String get uninstallReasonBattery => '耗电太快';

  @override
  String get uninstallReasonOthers => '其他';

  @override
  String get uninstallConfirmTitle => '您确定吗？';

  @override
  String get uninstallConfirmContent => '您要卸载此应用吗？';

  @override
  String get skip => '跳过';

  @override
  String get bornBaby => '已出生宝宝';

  @override
  String get unbornBaby => '未出生宝宝';

  @override
  String get createNow => '立即创建';

  @override
  String get generatingAiBaby => '正在生成AI宝宝照片...';

  @override
  String get analyzingFacialFeatures => '正在分析面部特征并生成结果';

  @override
  String get generationComplete => '完成！已保存到您的作品中。';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return '加载视频失败：$error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return '加载照片失败：$error';
  }

  @override
  String get filterVideo => '视频';

  @override
  String get filterPhoto => '照片';

  @override
  String get workFilesAvailable => '文件仅可用7天 — 立即保存';

  @override
  String get workGenerationFailed => '生成失败。请更换照片后重试。';

  @override
  String get workWaiting => '预计等待30分钟…';

  @override
  String get creationCompleted => '创建完成';

  @override
  String get taskSubmission => '任务提交';

  @override
  String get completed => '已完成';

  @override
  String get generationFailed => '生成失败';

  @override
  String generationOnTheWay(String title) {
    return '您的$title正在路上 🍼';
  }

  @override
  String get generationWaitMsg => '这可能需要大约1-2分钟。';

  @override
  String get somethingWentWrong => '出错了。\n请重试。';

  @override
  String get viewNow => '立即查看';

  @override
  String get goBack => '返回';

  @override
  String get buyPoints => '✦ 购买积分';

  @override
  String get submittingWait => '提交中，请稍候…';

  @override
  String get myPhoto => '我的照片';

  @override
  String get mothersPhoto => '妈妈的照片';

  @override
  String get fathersPhoto => '爸爸的照片';

  @override
  String get detectSimilarity => '检测相似度';

  @override
  String get babyPhotoLabel => '宝宝照片';

  @override
  String get gender => '性别';

  @override
  String get skinTone => '肤色';

  @override
  String get ultrasoundPhoto => '超声波照片';

  @override
  String get viewYourBaby => '查看您的宝宝';

  @override
  String get familyStyle => '家庭风格';

  @override
  String get generateFamilyPortrait => '生成家庭肖像';

  @override
  String get photoGuidanceGood => '包括肩膀、不同背景、服装、表情和头部角度。';

  @override
  String get photoGuidanceBad => '避免遮脸、墨镜、合照或遮盖特征的浓妆。';

  @override
  String get takeSelfie => '拍自拍';

  @override
  String get selectPhoto => '选择照片';
}
