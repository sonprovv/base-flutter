// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppL10nDe extends AppL10n {
  AppL10nDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Erschaffe magische Baby-Momente';

  @override
  String get splashAdDisclaimer => 'Diese Aktion kann Werbung enthalten';

  @override
  String get chooseLanguage => 'Sprache wählen';

  @override
  String get save => 'Speichern';

  @override
  String get onboarding1Title => 'Entdecke dein\nzukünftiges Baby';

  @override
  String get onboarding1Desc =>
      'Sieh, wie dein Baby aussehen wird, mit KI-gestützter Gesichtsgenerierung';

  @override
  String get onboarding2Title => 'Baby-Tanz\nVorlagen';

  @override
  String get onboarding2Desc =>
      'Erstelle süße Tanzvideos mit deinem Baby mit trendigen Vorlagen';

  @override
  String get onboarding3Title => 'Familien-\nÄhnlichkeit';

  @override
  String get onboarding3Desc => 'Entdecke, wem dein Baby am meisten ähnelt';

  @override
  String get next => 'Weiter';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get termsAgreement =>
      'Durch Fortfahren stimmst du unseren Nutzungsbedingungen und der Datenschutzrichtlinie zu';

  @override
  String get navHome => 'Startseite';

  @override
  String get navVideo => 'Video';

  @override
  String get navPhoto => 'Foto';

  @override
  String get navProfile => 'Profil';

  @override
  String get retry => 'Wiederholen';

  @override
  String get comingSoon => 'Demnächst!';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get error => 'Fehler';

  @override
  String get homeLoadError => 'Startseite konnte nicht geladen werden';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileUser => 'BabyGenie Nutzer';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString Kreationen';
  }

  @override
  String get filterAll => 'Alle';

  @override
  String get noCreationsYet => 'Noch keine Kreationen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get settingsRateApp => 'App bewerten';

  @override
  String get settingsShareApp => 'App teilen';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Mamas Foto';

  @override
  String get dadsPhoto => 'Papas Foto';

  @override
  String get babysPhoto => 'Babys Foto';

  @override
  String get boyOrGirl => 'Junge oder Mädchen';

  @override
  String get uploadPhotoHint =>
      'Lade klare Frontalfotos für beste Ergebnisse hoch';

  @override
  String get generateBabyPhoto => 'Baby-Foto erstellen';

  @override
  String get uploadPhoto => 'Foto hochladen';

  @override
  String get tapToSelectImage => 'Tippe zum Auswählen eines Bildes';

  @override
  String get babyGirl => 'Baby Mädchen';

  @override
  String get babyBoy => 'Baby Junge';

  @override
  String get teenGirl => 'Teenager Mädchen';

  @override
  String get teenBoy => 'Teenager Junge';

  @override
  String get noTemplatesFound => 'Keine Vorlagen gefunden';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Alle Premium-Funktionen freischalten';

  @override
  String get paywallTrial => 'TEST';

  @override
  String get paywallContinue => 'Weiter';

  @override
  String get paywallCancelNote => 'Jederzeit kündigen · Käufe wiederherstellen';

  @override
  String get uninstallSorry =>
      'Es tut uns leid, wenn wir deine Erwartungen nicht erfüllt haben.';

  @override
  String get uninstallImprove =>
      'Bitte teile uns mit, wie wir uns verbessern können.';

  @override
  String get uninstallNotUseful =>
      'Nicht viel nützlicher als die Standardfunktion';

  @override
  String get uninstallLaggy => 'Langsam oder nicht reagierend';

  @override
  String get explore => 'Erkunden';

  @override
  String get dontUninstall => 'Noch nicht deinstallieren';

  @override
  String get stillUninstall => 'Trotzdem deinstallieren';

  @override
  String get whyUninstall => 'Warum hast du die App deinstalliert?';

  @override
  String get uninstall => 'Deinstallieren';

  @override
  String get uninstallReasonDifficult => 'Schwer zu bedienen';

  @override
  String get uninstallReasonAds => 'Zu viele Werbeanzeigen';

  @override
  String get uninstallReasonError => 'Fehler, funktioniert nicht';

  @override
  String get uninstallReasonBattery => 'Schnelle Batterieentladung';

  @override
  String get uninstallReasonOthers => 'Andere';

  @override
  String get uninstallConfirmTitle => 'Bist du sicher?';

  @override
  String get uninstallConfirmContent => 'Möchtest du diese App deinstallieren?';

  @override
  String get skip => 'Überspringen';

  @override
  String get bornBaby => 'Geborenes Baby';

  @override
  String get unbornBaby => 'Ungeborenes Baby';

  @override
  String get createNow => 'Jetzt erstellen';

  @override
  String get generatingAiBaby => 'KI-Baby-Foto wird generiert...';

  @override
  String get analyzingFacialFeatures =>
      'Gesichtsmerkmale werden analysiert und Ergebnis wird generiert';

  @override
  String get generationComplete => 'Fertig! In Ihren Kreationen gespeichert.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Videos konnten nicht geladen werden: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Fotos konnten nicht geladen werden: $error';
  }

  @override
  String get filterVideo => 'Video';

  @override
  String get filterPhoto => 'Foto';

  @override
  String get workFilesAvailable =>
      'Dateien nur 7 Tage verfügbar — jetzt speichern';

  @override
  String get workGenerationFailed =>
      'Generierung fehlgeschlagen. Bitte ersetzen Sie das Foto und versuchen Sie es erneut.';

  @override
  String get workWaiting => 'Voraussichtliche Wartezeit 30 Minuten…';

  @override
  String get creationCompleted => 'Erstellung abgeschlossen';

  @override
  String get taskSubmission => 'Aufgabe wird übermittelt';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get generationFailed => 'Generierung fehlgeschlagen';

  @override
  String generationOnTheWay(String title) {
    return 'Ihr $title ist unterwegs 🍼';
  }

  @override
  String get generationWaitMsg => 'Dies kann etwa 1-2 Minuten dauern.';

  @override
  String get somethingWentWrong =>
      'Etwas ist schiefgelaufen.\nBitte versuchen Sie es erneut.';

  @override
  String get viewNow => 'Jetzt ansehen';

  @override
  String get goBack => 'Zurück';

  @override
  String get buyPoints => '✦ Punkte kaufen';

  @override
  String get submittingWait => 'Wird übermittelt, bitte warten…';

  @override
  String get myPhoto => 'Mein Foto';

  @override
  String get mothersPhoto => 'Foto der Mutter';

  @override
  String get fathersPhoto => 'Foto des Vaters';

  @override
  String get detectSimilarity => 'Ähnlichkeit erkennen';

  @override
  String get babyPhotoLabel => 'Baby-Foto';

  @override
  String get gender => 'Geschlecht';

  @override
  String get skinTone => 'Hautton';

  @override
  String get ultrasoundPhoto => 'Ultraschallfoto';

  @override
  String get viewYourBaby => 'Ihr Baby ansehen';

  @override
  String get familyStyle => 'Familienstil';

  @override
  String get generateFamilyPortrait => 'Familienporträt generieren';

  @override
  String get photoGuidanceGood =>
      'Schultern, verschiedene Hintergründe, Kleidung, Ausdrücke und Kopfwinkel einbeziehen.';

  @override
  String get photoGuidanceBad =>
      'Verdeckte Gesichter, Sonnenbrillen, Gruppenfotos oder starkes Make-up vermeiden.';

  @override
  String get takeSelfie => 'Selfie aufnehmen';

  @override
  String get selectPhoto => 'Foto auswählen';
}
