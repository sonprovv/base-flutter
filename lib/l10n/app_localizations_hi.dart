// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppL10nHi extends AppL10n {
  AppL10nHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'बच्चे के जादुई पल बनाएं';

  @override
  String get splashAdDisclaimer => 'इस ऐप में विज्ञापन हो सकते हैं';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get save => 'सहेजें';

  @override
  String get onboarding1Title => 'अपना\nभावी बच्चा देखें';

  @override
  String get onboarding1Desc => 'AI से देखें कि आपका बच्चा कैसा दिखेगा';

  @override
  String get onboarding2Title => 'बेबी डांस\nटेम्पलेट';

  @override
  String get onboarding2Desc =>
      'ट्रेंडिंग टेम्पलेट से अपने बच्चे के साथ प्यारे डांस वीडियो बनाएं';

  @override
  String get onboarding3Title => 'परिवार\nसमानता';

  @override
  String get onboarding3Desc => 'जानें आपका बच्चा सबसे ज़्यादा किससे मिलता है';

  @override
  String get next => 'अगला';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get termsAgreement =>
      'जारी रखने पर आप हमारी शर्तें और गोपनीयता नीति मानते हैं';

  @override
  String get navHome => 'होम';

  @override
  String get navVideo => 'वीडियो';

  @override
  String get navPhoto => 'फ़ोटो';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get comingSoon => 'जल्द आ रहा है!';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get error => 'त्रुटि';

  @override
  String get homeLoadError => 'होम लोड करने में विफल';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileUser => 'BabyGenie उपयोगकर्ता';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString रचनाएं';
  }

  @override
  String get filterAll => 'सभी';

  @override
  String get noCreationsYet => 'अभी कोई रचना नहीं';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get settingsRateApp => 'ऐप को रेट करें';

  @override
  String get settingsShareApp => 'ऐप साझा करें';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'माँ की फ़ोटो';

  @override
  String get dadsPhoto => 'पिता की फ़ोटो';

  @override
  String get babysPhoto => 'बच्चे की फ़ोटो';

  @override
  String get boyOrGirl => 'लड़का या लड़की';

  @override
  String get uploadPhotoHint =>
      'सर्वोत्तम परिणाम के लिए स्पष्ट, सामने की फ़ोटो अपलोड करें';

  @override
  String get generateBabyPhoto => 'बेबी फ़ोटो बनाएं';

  @override
  String get uploadPhoto => 'फ़ोटो अपलोड करें';

  @override
  String get tapToSelectImage => 'छवि चुनने के लिए टैप करें';

  @override
  String get babyGirl => 'बेबी गर्ल';

  @override
  String get babyBoy => 'बेबी बॉय';

  @override
  String get teenGirl => 'टीन गर्ल';

  @override
  String get teenBoy => 'टीन बॉय';

  @override
  String get noTemplatesFound => 'कोई टेम्पलेट नहीं मिला';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'सभी प्रीमियम सुविधाएं अनलॉक करें';

  @override
  String get paywallTrial => 'परीक्षण';

  @override
  String get paywallContinue => 'जारी रखें';

  @override
  String get paywallCancelNote =>
      'कभी भी रद्द करें · खरीदारी पुनः प्राप्त करें';

  @override
  String get uninstallSorry =>
      'हमें खेद है अगर हम आपकी उम्मीदों पर खरे नहीं उतरे.';

  @override
  String get uninstallImprove =>
      'कृपया हमें बताएं कि हम कैसे सुधार कर सकते हैं.';

  @override
  String get uninstallNotUseful =>
      'डिफ़ॉल्ट सुविधा से बहुत ज़्यादा उपयोगी नहीं';

  @override
  String get uninstallLaggy => 'धीमा या अनुत्तरदायी';

  @override
  String get explore => 'खोजें';

  @override
  String get dontUninstall => 'अभी अनइंस्टॉल न करें';

  @override
  String get stillUninstall => 'फिर भी अनइंस्टॉल करना चाहते हैं';

  @override
  String get whyUninstall => 'आपने ऐप क्यों अनइंस्टॉल किया?';

  @override
  String get uninstall => 'अनइंस्टॉल';

  @override
  String get uninstallReasonDifficult => 'उपयोग करना कठिन';

  @override
  String get uninstallReasonAds => 'बहुत अधिक विज्ञापन';

  @override
  String get uninstallReasonError => 'त्रुटि काम नहीं कर रही';

  @override
  String get uninstallReasonBattery => 'तेज़ बैटरी खपत';

  @override
  String get uninstallReasonOthers => 'अन्य';

  @override
  String get uninstallConfirmTitle => 'क्या आप निश्चित हैं?';

  @override
  String get uninstallConfirmContent => 'आप इस ऐप को अनइंस्टॉल करना चाहते हैं?';

  @override
  String get skip => 'छोड़ें';

  @override
  String get bornBaby => 'जन्मा बच्चा';

  @override
  String get unbornBaby => 'अजन्मा बच्चा';

  @override
  String get createNow => 'अभी बनाएं';

  @override
  String get generatingAiBaby => 'AI बेबी फोटो बना रहे हैं...';

  @override
  String get analyzingFacialFeatures =>
      'चेहरे की विशेषताओं का विश्लेषण कर रहे हैं';

  @override
  String get generationComplete => 'पूर्ण! आपकी रचनाओं में सहेजा गया।';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'वीडियो लोड करने में विफल: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'फ़ोटो लोड करने में विफल: $error';
  }

  @override
  String get filterVideo => 'वीडियो';

  @override
  String get filterPhoto => 'फ़ोटो';

  @override
  String get workFilesAvailable =>
      'फ़ाइलें केवल 7 दिनों तक उपलब्ध — अभी सहेजें';

  @override
  String get workGenerationFailed =>
      'निर्माण विफल। कृपया फ़ोटो बदलें और पुनः प्रयास करें।';

  @override
  String get workWaiting => '30 मिनट प्रतीक्षा की उम्मीद…';

  @override
  String get creationCompleted => 'निर्माण पूर्ण';

  @override
  String get taskSubmission => 'कार्य सबमिशन';

  @override
  String get completed => 'पूर्ण';

  @override
  String get generationFailed => 'निर्माण विफल';

  @override
  String generationOnTheWay(String title) {
    return 'आपकी $title रास्ते में है 🍼';
  }

  @override
  String get generationWaitMsg => 'इसमें लगभग 1-2 मिनट लग सकते हैं।';

  @override
  String get somethingWentWrong => 'कुछ गलत हुआ।\nकृपया पुनः प्रयास करें।';

  @override
  String get viewNow => 'अभी देखें';

  @override
  String get goBack => 'वापस जाएं';

  @override
  String get buyPoints => '✦ पॉइंट खरीदें';

  @override
  String get submittingWait => 'सबमिट हो रहा है, कृपया प्रतीक्षा करें…';

  @override
  String get myPhoto => 'मेरी फ़ोटो';

  @override
  String get mothersPhoto => 'माँ की फ़ोटो';

  @override
  String get fathersPhoto => 'पिता की फ़ोटो';

  @override
  String get detectSimilarity => 'समानता पहचानें';

  @override
  String get babyPhotoLabel => 'बच्चे की फ़ोटो';

  @override
  String get gender => 'लिंग';

  @override
  String get skinTone => 'त्वचा का रंग';

  @override
  String get ultrasoundPhoto => 'अल्ट्रासाउंड फ़ोटो';

  @override
  String get viewYourBaby => 'अपना बच्चा देखें';

  @override
  String get familyStyle => 'परिवार शैली';

  @override
  String get generateFamilyPortrait => 'पारिवारिक चित्र बनाएं';

  @override
  String get photoGuidanceGood =>
      'कंधे, विभिन्न पृष्ठभूमि, कपड़े, भाव और सिर के कोण शामिल करें।';

  @override
  String get photoGuidanceBad =>
      'ढके हुए चेहरे, धूप के चश्मे, समूह फ़ोटो, या भारी मेकअप से बचें।';

  @override
  String get takeSelfie => 'सेल्फ़ी लें';

  @override
  String get selectPhoto => 'फ़ोटो चुनें';
}
