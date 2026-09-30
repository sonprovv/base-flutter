// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppL10nEn extends AppL10n {
  AppL10nEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Create magical baby moments';

  @override
  String get splashAdDisclaimer => 'This action may contain ads';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get save => 'Save';

  @override
  String get onboarding1Title => 'Discover Your\nFuture Baby';

  @override
  String get onboarding1Desc =>
      'See what your baby will look like with AI-powered face generation';

  @override
  String get onboarding2Title => 'Baby Dance\nTemplates';

  @override
  String get onboarding2Desc =>
      'Create adorable dance videos with your baby using trending templates';

  @override
  String get onboarding3Title => 'Family\nSimilarity';

  @override
  String get onboarding3Desc =>
      'Discover who your baby looks like most with our similarity detection';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get termsAgreement =>
      'By continuing, you agree to our Terms & Privacy Policy';

  @override
  String get navHome => 'Home';

  @override
  String get navVideo => 'Video';

  @override
  String get navPhoto => 'Photo';

  @override
  String get navProfile => 'Profile';

  @override
  String get retry => 'Retry';

  @override
  String get comingSoon => 'Coming soon!';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get error => 'Error';

  @override
  String get homeLoadError => 'Failed to load home';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUser => 'BabyGenie User';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString creations';
  }

  @override
  String get filterAll => 'All';

  @override
  String get noCreationsYet => 'No creations yet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsRateApp => 'Rate App';

  @override
  String get settingsShareApp => 'Share App';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Mom\'s Photo';

  @override
  String get dadsPhoto => 'Dad\'s Photo';

  @override
  String get babysPhoto => 'Baby\'s Photo';

  @override
  String get boyOrGirl => 'Boy or Girl';

  @override
  String get uploadPhotoHint =>
      'Upload clear, front-facing photos for best results';

  @override
  String get generateBabyPhoto => 'Generate Baby Photo';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get tapToSelectImage => 'Tap to select an Image';

  @override
  String get babyGirl => 'Baby Girl';

  @override
  String get babyBoy => 'Baby Boy';

  @override
  String get teenGirl => 'Teen Girl';

  @override
  String get teenBoy => 'Teen Boy';

  @override
  String get noTemplatesFound => 'No templates found';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Unlock all premium features';

  @override
  String get paywallTrial => 'TRIAL';

  @override
  String get paywallContinue => 'Continue';

  @override
  String get paywallCancelNote => 'Cancel anytime · Restore purchases';

  @override
  String get uninstallSorry =>
      'We’re truly sorry if we haven’t met your expectations.';

  @override
  String get uninstallImprove => 'Please let us know how we can improve.';

  @override
  String get uninstallNotUseful =>
      'Not much more useful than the default feature';

  @override
  String get uninstallLaggy => 'Unresponsive or Laggy';

  @override
  String get explore => 'Explore';

  @override
  String get dontUninstall => 'Don’t uninstall yet';

  @override
  String get stillUninstall => 'Still want to uninstall';

  @override
  String get whyUninstall => 'Why did you uninstall the app?';

  @override
  String get uninstall => 'Uninstall';

  @override
  String get uninstallReasonDifficult => 'Difficult to use';

  @override
  String get uninstallReasonAds => 'Too many ads';

  @override
  String get uninstallReasonError => 'Error Not Working';

  @override
  String get uninstallReasonBattery => 'Fast battery drain';

  @override
  String get uninstallReasonOthers => 'Others';

  @override
  String get uninstallConfirmTitle => 'Are you sure?';

  @override
  String get uninstallConfirmContent => 'You want to uninstall this app?';

  @override
  String get skip => 'Skip';

  @override
  String get bornBaby => 'Born Baby';

  @override
  String get unbornBaby => 'Unborn Baby';

  @override
  String get createNow => 'Create Now';

  @override
  String get generatingAiBaby => 'Generating AI Baby...';

  @override
  String get analyzingFacialFeatures =>
      'Analyzing facial features and generating result';

  @override
  String get generationComplete =>
      'Generation complete! Saved to your creations.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Failed to load videos: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Failed to load photos: $error';
  }

  @override
  String get filterVideo => 'Video';

  @override
  String get filterPhoto => 'Photo';

  @override
  String get workFilesAvailable => 'Files only available for 7 days — save now';

  @override
  String get workGenerationFailed =>
      'Generation failed. Please replace the photo and try again.';

  @override
  String get workWaiting => 'Expected to wait for 30 minutes…';

  @override
  String get creationCompleted => 'Creation completed';

  @override
  String get taskSubmission => 'Task Submission';

  @override
  String get completed => 'Completed';

  @override
  String get generationFailed => 'Generation failed';

  @override
  String generationOnTheWay(String title) {
    return 'Your $title is on the way 🍼';
  }

  @override
  String get generationWaitMsg => 'This may take about 1–2 minutes.';

  @override
  String get somethingWentWrong => 'Something went wrong.\nPlease try again.';

  @override
  String get viewNow => 'View now';

  @override
  String get goBack => 'Go back';

  @override
  String get buyPoints => '✦ Buy Points';

  @override
  String get submittingWait => 'Submitting, please wait…';

  @override
  String get myPhoto => 'My Photo';

  @override
  String get mothersPhoto => 'Mother\'s Photo';

  @override
  String get fathersPhoto => 'Father\'s Photo';

  @override
  String get detectSimilarity => 'Detect Similarity';

  @override
  String get babyPhotoLabel => 'Baby Photo';

  @override
  String get gender => 'Gender';

  @override
  String get skinTone => 'Skin Tone';

  @override
  String get ultrasoundPhoto => 'Ultrasound Photo';

  @override
  String get viewYourBaby => 'View Your Baby';

  @override
  String get familyStyle => 'Family Style';

  @override
  String get generateFamilyPortrait => 'Generate Family Portrait';

  @override
  String get photoGuidanceGood =>
      'Include shoulders, varied backgrounds, clothing, emotions, and head angles.';

  @override
  String get photoGuidanceBad =>
      'Avoid covered faces, sunglasses, group shots, or heavy makeup that hides features.';

  @override
  String get takeSelfie => 'Take a Selfie';

  @override
  String get selectPhoto => 'Select a Photo';
}
