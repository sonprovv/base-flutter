// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppL10nAr extends AppL10n {
  AppL10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'خلق لحظات سحرية لطفلك';

  @override
  String get splashAdDisclaimer => 'قد يحتوي هذا المحتوى على إعلانات';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get save => 'حفظ';

  @override
  String get onboarding1Title => 'اكتشف\nطفلك المستقبلي';

  @override
  String get onboarding1Desc => 'شاهد كيف سيبدو طفلك بتقنية الذكاء الاصطناعي';

  @override
  String get onboarding2Title => 'قوالب\nرقص الأطفال';

  @override
  String get onboarding2Desc =>
      'أنشئ مقاطع رقص رائعة مع طفلك باستخدام القوالب الرائجة';

  @override
  String get onboarding3Title => 'تشابه\nالعائلة';

  @override
  String get onboarding3Desc =>
      'اكتشف من يشبه طفلك أكثر بتقنية الكشف عن التشابه';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get termsAgreement =>
      'بالمتابعة، أنت توافق على الشروط وسياسة الخصوصية';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navVideo => 'فيديو';

  @override
  String get navPhoto => 'صورة';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get comingSoon => 'قريباً!';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get error => 'خطأ';

  @override
  String get homeLoadError => 'فشل تحميل الصفحة الرئيسية';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get profileUser => 'مستخدم BabyGenie';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString إبداعات';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get noCreationsYet => 'لا توجد إبداعات بعد';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsRateApp => 'تقييم التطبيق';

  @override
  String get settingsShareApp => 'مشاركة التطبيق';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'صورة الأم';

  @override
  String get dadsPhoto => 'صورة الأب';

  @override
  String get babysPhoto => 'صورة الطفل';

  @override
  String get boyOrGirl => 'ولد أم بنت';

  @override
  String get uploadPhotoHint =>
      'ارفع صوراً واضحة للوجه للحصول على أفضل النتائج';

  @override
  String get generateBabyPhoto => 'إنشاء صورة الطفل';

  @override
  String get uploadPhoto => 'رفع صورة';

  @override
  String get tapToSelectImage => 'اضغط لاختيار صورة';

  @override
  String get babyGirl => 'طفلة';

  @override
  String get babyBoy => 'طفل';

  @override
  String get teenGirl => 'مراهقة';

  @override
  String get teenBoy => 'مراهق';

  @override
  String get noTemplatesFound => 'لا توجد قوالب';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'افتح جميع الميزات المميزة';

  @override
  String get paywallTrial => 'تجريبي';

  @override
  String get paywallContinue => 'متابعة';

  @override
  String get paywallCancelNote => 'إلغاء في أي وقت · استعادة المشتريات';

  @override
  String get uninstallSorry => 'نأسف حقاً إذا لم نلبِّ توقعاتك.';

  @override
  String get uninstallImprove => 'أخبرنا كيف يمكننا التحسين.';

  @override
  String get uninstallNotUseful => 'ليس أكثر فائدة من الميزة الافتراضية';

  @override
  String get uninstallLaggy => 'بطيء أو لا يستجيب';

  @override
  String get explore => 'استكشاف';

  @override
  String get dontUninstall => 'لا تحذف التطبيق بعد';

  @override
  String get stillUninstall => 'ما زلت أريد الحذف';

  @override
  String get whyUninstall => 'لماذا حذفت التطبيق؟';

  @override
  String get uninstall => 'حذف';

  @override
  String get uninstallReasonDifficult => 'صعب الاستخدام';

  @override
  String get uninstallReasonAds => 'إعلانات كثيرة جداً';

  @override
  String get uninstallReasonError => 'خطأ لا يعمل';

  @override
  String get uninstallReasonBattery => 'استنزاف سريع للبطارية';

  @override
  String get uninstallReasonOthers => 'أسباب أخرى';

  @override
  String get uninstallConfirmTitle => 'هل أنت متأكد؟';

  @override
  String get uninstallConfirmContent => 'تريد حذف هذا التطبيق؟';

  @override
  String get skip => 'تخطي';

  @override
  String get bornBaby => 'طفل مولود';

  @override
  String get unbornBaby => 'طفل لم يولد بعد';

  @override
  String get createNow => 'إنشاء الآن';

  @override
  String get generatingAiBaby => 'جارٍ إنشاء صورة الطفل بالذكاء الاصطناعي...';

  @override
  String get analyzingFacialFeatures => 'تحليل ملامح الوجه وإنشاء النتيجة';

  @override
  String get generationComplete => 'اكتمل! تم الحفظ في إبداعاتك.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'فشل تحميل الفيديوهات: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'فشل تحميل الصور: $error';
  }

  @override
  String get filterVideo => 'فيديو';

  @override
  String get filterPhoto => 'صورة';

  @override
  String get workFilesAvailable => 'الملفات متاحة فقط لمدة 7 أيام — احفظ الآن';

  @override
  String get workGenerationFailed =>
      'فشل الإنشاء. يرجى استبدال الصورة والمحاولة مرة أخرى.';

  @override
  String get workWaiting => 'متوقع الانتظار 30 دقيقة…';

  @override
  String get creationCompleted => 'اكتمل الإنشاء';

  @override
  String get taskSubmission => 'جارٍ التقديم';

  @override
  String get completed => 'مكتمل';

  @override
  String get generationFailed => 'فشل الإنشاء';

  @override
  String generationOnTheWay(String title) {
    return 'صورة $title في الطريق 🍼';
  }

  @override
  String get generationWaitMsg => 'قد يستغرق ذلك حوالي 1-2 دقيقة.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما.\nيرجى المحاولة مرة أخرى.';

  @override
  String get viewNow => 'عرض الآن';

  @override
  String get goBack => 'الرجوع';

  @override
  String get buyPoints => '✦ شراء النقاط';

  @override
  String get submittingWait => 'جارٍ الإرسال، يرجى الانتظار…';

  @override
  String get myPhoto => 'صوري';

  @override
  String get mothersPhoto => 'صورة الأم';

  @override
  String get fathersPhoto => 'صورة الأب';

  @override
  String get detectSimilarity => 'اكتشاف التشابه';

  @override
  String get babyPhotoLabel => 'صورة الطفل';

  @override
  String get gender => 'الجنس';

  @override
  String get skinTone => 'درجة لون البشرة';

  @override
  String get ultrasoundPhoto => 'صورة الموجات فوق الصوتية';

  @override
  String get viewYourBaby => 'شاهد طفلك';

  @override
  String get familyStyle => 'نمط العائلة';

  @override
  String get generateFamilyPortrait => 'إنشاء صورة عائلية';

  @override
  String get photoGuidanceGood =>
      'تضمين الكتفين، خلفيات متنوعة، الملابس، التعبيرات، وزوايا الرأس.';

  @override
  String get photoGuidanceBad =>
      'تجنب الوجوه المغطاة، النظارات الشمسية، الصور الجماعية، أو المكياج الثقيل.';

  @override
  String get takeSelfie => 'التقط صورة سيلفي';

  @override
  String get selectPhoto => 'اختر صورة';
}
