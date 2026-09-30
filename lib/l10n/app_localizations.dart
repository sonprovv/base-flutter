import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppL10n
/// returned by `AppL10n.of(context)`.
///
/// Applications need to include `AppL10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppL10n.localizationsDelegates,
///   supportedLocales: AppL10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppL10n.supportedLocales
/// property.
abstract class AppL10n {
  AppL10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppL10n? of(BuildContext context) {
    return Localizations.of<AppL10n>(context, AppL10n);
  }

  static const LocalizationsDelegate<AppL10n> delegate = _AppL10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('ru'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'BabyGenie'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Create magical baby moments'**
  String get splashTagline;

  /// No description provided for @splashAdDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This action may contain ads'**
  String get splashAdDisclaimer;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover Your\nFuture Baby'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'See what your baby will look like with AI-powered face generation'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Baby Dance\nTemplates'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Create adorable dance videos with your baby using trending templates'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Family\nSimilarity'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Discover who your baby looks like most with our similarity detection'**
  String get onboarding3Desc;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms & Privacy Policy'**
  String get termsAgreement;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get navVideo;

  /// No description provided for @navPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get navPhoto;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get comingSoon;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @homeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load home'**
  String get homeLoadError;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUser.
  ///
  /// In en, this message translates to:
  /// **'BabyGenie User'**
  String get profileUser;

  /// No description provided for @profileCreations.
  ///
  /// In en, this message translates to:
  /// **'{count} creations'**
  String profileCreations(int count);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @noCreationsYet.
  ///
  /// In en, this message translates to:
  /// **'No creations yet'**
  String get noCreationsYet;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get settingsRateApp;

  /// No description provided for @settingsShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get settingsShareApp;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'BabyGenie v1.0.0'**
  String get appVersion;

  /// No description provided for @momsPhoto.
  ///
  /// In en, this message translates to:
  /// **'Mom\'s Photo'**
  String get momsPhoto;

  /// No description provided for @dadsPhoto.
  ///
  /// In en, this message translates to:
  /// **'Dad\'s Photo'**
  String get dadsPhoto;

  /// No description provided for @babysPhoto.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s Photo'**
  String get babysPhoto;

  /// No description provided for @boyOrGirl.
  ///
  /// In en, this message translates to:
  /// **'Boy or Girl'**
  String get boyOrGirl;

  /// No description provided for @uploadPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Upload clear, front-facing photos for best results'**
  String get uploadPhotoHint;

  /// No description provided for @generateBabyPhoto.
  ///
  /// In en, this message translates to:
  /// **'Generate Baby Photo'**
  String get generateBabyPhoto;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @tapToSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to select an Image'**
  String get tapToSelectImage;

  /// No description provided for @babyGirl.
  ///
  /// In en, this message translates to:
  /// **'Baby Girl'**
  String get babyGirl;

  /// No description provided for @babyBoy.
  ///
  /// In en, this message translates to:
  /// **'Baby Boy'**
  String get babyBoy;

  /// No description provided for @teenGirl.
  ///
  /// In en, this message translates to:
  /// **'Teen Girl'**
  String get teenGirl;

  /// No description provided for @teenBoy.
  ///
  /// In en, this message translates to:
  /// **'Teen Boy'**
  String get teenBoy;

  /// No description provided for @noTemplatesFound.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get noTemplatesFound;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'BabyGenie PRO'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock all premium features'**
  String get paywallSubtitle;

  /// No description provided for @paywallTrial.
  ///
  /// In en, this message translates to:
  /// **'TRIAL'**
  String get paywallTrial;

  /// No description provided for @paywallContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get paywallContinue;

  /// No description provided for @paywallCancelNote.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime · Restore purchases'**
  String get paywallCancelNote;

  /// No description provided for @uninstallSorry.
  ///
  /// In en, this message translates to:
  /// **'We’re truly sorry if we haven’t met your expectations.'**
  String get uninstallSorry;

  /// No description provided for @uninstallImprove.
  ///
  /// In en, this message translates to:
  /// **'Please let us know how we can improve.'**
  String get uninstallImprove;

  /// No description provided for @uninstallNotUseful.
  ///
  /// In en, this message translates to:
  /// **'Not much more useful than the default feature'**
  String get uninstallNotUseful;

  /// No description provided for @uninstallLaggy.
  ///
  /// In en, this message translates to:
  /// **'Unresponsive or Laggy'**
  String get uninstallLaggy;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @dontUninstall.
  ///
  /// In en, this message translates to:
  /// **'Don’t uninstall yet'**
  String get dontUninstall;

  /// No description provided for @stillUninstall.
  ///
  /// In en, this message translates to:
  /// **'Still want to uninstall'**
  String get stillUninstall;

  /// No description provided for @whyUninstall.
  ///
  /// In en, this message translates to:
  /// **'Why did you uninstall the app?'**
  String get whyUninstall;

  /// No description provided for @uninstall.
  ///
  /// In en, this message translates to:
  /// **'Uninstall'**
  String get uninstall;

  /// No description provided for @uninstallReasonDifficult.
  ///
  /// In en, this message translates to:
  /// **'Difficult to use'**
  String get uninstallReasonDifficult;

  /// No description provided for @uninstallReasonAds.
  ///
  /// In en, this message translates to:
  /// **'Too many ads'**
  String get uninstallReasonAds;

  /// No description provided for @uninstallReasonError.
  ///
  /// In en, this message translates to:
  /// **'Error Not Working'**
  String get uninstallReasonError;

  /// No description provided for @uninstallReasonBattery.
  ///
  /// In en, this message translates to:
  /// **'Fast battery drain'**
  String get uninstallReasonBattery;

  /// No description provided for @uninstallReasonOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get uninstallReasonOthers;

  /// No description provided for @uninstallConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get uninstallConfirmTitle;

  /// No description provided for @uninstallConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'You want to uninstall this app?'**
  String get uninstallConfirmContent;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @bornBaby.
  ///
  /// In en, this message translates to:
  /// **'Born Baby'**
  String get bornBaby;

  /// No description provided for @unbornBaby.
  ///
  /// In en, this message translates to:
  /// **'Unborn Baby'**
  String get unbornBaby;

  /// No description provided for @createNow.
  ///
  /// In en, this message translates to:
  /// **'Create Now'**
  String get createNow;

  /// No description provided for @generatingAiBaby.
  ///
  /// In en, this message translates to:
  /// **'Generating AI Baby...'**
  String get generatingAiBaby;

  /// No description provided for @analyzingFacialFeatures.
  ///
  /// In en, this message translates to:
  /// **'Analyzing facial features and generating result'**
  String get analyzingFacialFeatures;

  /// No description provided for @generationComplete.
  ///
  /// In en, this message translates to:
  /// **'Generation complete! Saved to your creations.'**
  String get generationComplete;

  /// No description provided for @babyDanceTitle.
  ///
  /// In en, this message translates to:
  /// **'BabyDance'**
  String get babyDanceTitle;

  /// No description provided for @failedToLoadVideos.
  ///
  /// In en, this message translates to:
  /// **'Failed to load videos: {error}'**
  String failedToLoadVideos(String error);

  /// No description provided for @babyTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'BabyTemplate'**
  String get babyTemplateTitle;

  /// No description provided for @failedToLoadPhotos.
  ///
  /// In en, this message translates to:
  /// **'Failed to load photos: {error}'**
  String failedToLoadPhotos(String error);

  /// No description provided for @filterVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get filterVideo;

  /// No description provided for @filterPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get filterPhoto;

  /// No description provided for @workFilesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Files only available for 7 days — save now'**
  String get workFilesAvailable;

  /// No description provided for @workGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed. Please replace the photo and try again.'**
  String get workGenerationFailed;

  /// No description provided for @workWaiting.
  ///
  /// In en, this message translates to:
  /// **'Expected to wait for 30 minutes…'**
  String get workWaiting;

  /// No description provided for @creationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Creation completed'**
  String get creationCompleted;

  /// No description provided for @taskSubmission.
  ///
  /// In en, this message translates to:
  /// **'Task Submission'**
  String get taskSubmission;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @generationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed'**
  String get generationFailed;

  /// No description provided for @generationOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Your {title} is on the way 🍼'**
  String generationOnTheWay(String title);

  /// No description provided for @generationWaitMsg.
  ///
  /// In en, this message translates to:
  /// **'This may take about 1–2 minutes.'**
  String get generationWaitMsg;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.\nPlease try again.'**
  String get somethingWentWrong;

  /// No description provided for @viewNow.
  ///
  /// In en, this message translates to:
  /// **'View now'**
  String get viewNow;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @buyPoints.
  ///
  /// In en, this message translates to:
  /// **'✦ Buy Points'**
  String get buyPoints;

  /// No description provided for @submittingWait.
  ///
  /// In en, this message translates to:
  /// **'Submitting, please wait…'**
  String get submittingWait;

  /// No description provided for @myPhoto.
  ///
  /// In en, this message translates to:
  /// **'My Photo'**
  String get myPhoto;

  /// No description provided for @mothersPhoto.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Photo'**
  String get mothersPhoto;

  /// No description provided for @fathersPhoto.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Photo'**
  String get fathersPhoto;

  /// No description provided for @detectSimilarity.
  ///
  /// In en, this message translates to:
  /// **'Detect Similarity'**
  String get detectSimilarity;

  /// No description provided for @babyPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Baby Photo'**
  String get babyPhotoLabel;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @skinTone.
  ///
  /// In en, this message translates to:
  /// **'Skin Tone'**
  String get skinTone;

  /// No description provided for @ultrasoundPhoto.
  ///
  /// In en, this message translates to:
  /// **'Ultrasound Photo'**
  String get ultrasoundPhoto;

  /// No description provided for @viewYourBaby.
  ///
  /// In en, this message translates to:
  /// **'View Your Baby'**
  String get viewYourBaby;

  /// No description provided for @familyStyle.
  ///
  /// In en, this message translates to:
  /// **'Family Style'**
  String get familyStyle;

  /// No description provided for @generateFamilyPortrait.
  ///
  /// In en, this message translates to:
  /// **'Generate Family Portrait'**
  String get generateFamilyPortrait;

  /// No description provided for @photoGuidanceGood.
  ///
  /// In en, this message translates to:
  /// **'Include shoulders, varied backgrounds, clothing, emotions, and head angles.'**
  String get photoGuidanceGood;

  /// No description provided for @photoGuidanceBad.
  ///
  /// In en, this message translates to:
  /// **'Avoid covered faces, sunglasses, group shots, or heavy makeup that hides features.'**
  String get photoGuidanceBad;

  /// No description provided for @takeSelfie.
  ///
  /// In en, this message translates to:
  /// **'Take a Selfie'**
  String get takeSelfie;

  /// No description provided for @selectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Select a Photo'**
  String get selectPhoto;
}

class _AppL10nDelegate extends LocalizationsDelegate<AppL10n> {
  const _AppL10nDelegate();

  @override
  Future<AppL10n> load(Locale locale) {
    return SynchronousFuture<AppL10n>(lookupAppL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'pt',
    'ru',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppL10nDelegate old) => false;
}

AppL10n lookupAppL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppL10nAr();
    case 'de':
      return AppL10nDe();
    case 'en':
      return AppL10nEn();
    case 'es':
      return AppL10nEs();
    case 'fr':
      return AppL10nFr();
    case 'hi':
      return AppL10nHi();
    case 'id':
      return AppL10nId();
    case 'pt':
      return AppL10nPt();
    case 'ru':
      return AppL10nRu();
    case 'vi':
      return AppL10nVi();
    case 'zh':
      return AppL10nZh();
  }

  throw FlutterError(
    'AppL10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
