// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppL10nFr extends AppL10n {
  AppL10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Créez des moments magiques pour bébé';

  @override
  String get splashAdDisclaimer => 'Cette action peut contenir des publicités';

  @override
  String get chooseLanguage => 'Choisir la langue';

  @override
  String get save => 'Sauvegarder';

  @override
  String get onboarding1Title => 'Découvrez votre\nFutur Bébé';

  @override
  String get onboarding1Desc =>
      'Voyez à quoi ressemblera votre bébé avec la génération de visages par IA';

  @override
  String get onboarding2Title => 'Modèles de\nDanse pour Bébé';

  @override
  String get onboarding2Desc =>
      'Créez d\'adorables vidéos de danse avec votre bébé avec des modèles tendance';

  @override
  String get onboarding3Title => 'Similarité\nFamiliale';

  @override
  String get onboarding3Desc =>
      'Découvrez à qui ressemble le plus votre bébé grâce à notre détection de similarité';

  @override
  String get next => 'Suivant';

  @override
  String get getStarted => 'Commencer';

  @override
  String get termsAgreement =>
      'En continuant, vous acceptez nos Conditions et notre Politique de confidentialité';

  @override
  String get navHome => 'Accueil';

  @override
  String get navVideo => 'Vidéo';

  @override
  String get navPhoto => 'Photo';

  @override
  String get navProfile => 'Profil';

  @override
  String get retry => 'Réessayer';

  @override
  String get comingSoon => 'Bientôt disponible !';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get error => 'Erreur';

  @override
  String get homeLoadError => 'Échec du chargement de l\'accueil';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileUser => 'Utilisateur BabyGenie';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString créations';
  }

  @override
  String get filterAll => 'Tout';

  @override
  String get noCreationsYet => 'Aucune création pour l\'instant';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsRateApp => 'Évaluer l\'App';

  @override
  String get settingsShareApp => 'Partager l\'App';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Photo de Maman';

  @override
  String get dadsPhoto => 'Photo de Papa';

  @override
  String get babysPhoto => 'Photo du Bébé';

  @override
  String get boyOrGirl => 'Garçon ou Fille';

  @override
  String get uploadPhotoHint =>
      'Téléchargez des photos claires de face pour de meilleurs résultats';

  @override
  String get generateBabyPhoto => 'Générer Photo de Bébé';

  @override
  String get uploadPhoto => 'Télécharger Photo';

  @override
  String get tapToSelectImage => 'Appuyez pour sélectionner une image';

  @override
  String get babyGirl => 'Bébé Fille';

  @override
  String get babyBoy => 'Bébé Garçon';

  @override
  String get teenGirl => 'Adolescente';

  @override
  String get teenBoy => 'Adolescent';

  @override
  String get noTemplatesFound => 'Aucun modèle trouvé';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Débloquer toutes les fonctionnalités premium';

  @override
  String get paywallTrial => 'ESSAI';

  @override
  String get paywallContinue => 'Continuer';

  @override
  String get paywallCancelNote =>
      'Annulez à tout moment · Restaurer les achats';

  @override
  String get uninstallSorry =>
      'Nous sommes vraiment désolés si nous n\'avons pas répondu à vos attentes.';

  @override
  String get uninstallImprove =>
      'Dites-nous comment nous pouvons nous améliorer.';

  @override
  String get uninstallNotUseful =>
      'Pas beaucoup plus utile que la fonction par défaut';

  @override
  String get uninstallLaggy => 'Lent ou sans réponse';

  @override
  String get explore => 'Explorer';

  @override
  String get dontUninstall => 'Ne pas désinstaller encore';

  @override
  String get stillUninstall => 'Je veux quand même désinstaller';

  @override
  String get whyUninstall => 'Pourquoi avez-vous désinstallé l\'app ?';

  @override
  String get uninstall => 'Désinstaller';

  @override
  String get uninstallReasonDifficult => 'Difficile à utiliser';

  @override
  String get uninstallReasonAds => 'Trop de publicités';

  @override
  String get uninstallReasonError => 'Erreur, ne fonctionne pas';

  @override
  String get uninstallReasonBattery => 'Décharge rapide de la batterie';

  @override
  String get uninstallReasonOthers => 'Autres';

  @override
  String get uninstallConfirmTitle => 'Êtes-vous sûr ?';

  @override
  String get uninstallConfirmContent => 'Voulez-vous désinstaller cette app ?';

  @override
  String get skip => 'Passer';

  @override
  String get bornBaby => 'Bébé né';

  @override
  String get unbornBaby => 'Bébé à naître';

  @override
  String get createNow => 'Créer maintenant';

  @override
  String get generatingAiBaby => 'Génération de photo de bébé IA...';

  @override
  String get analyzingFacialFeatures =>
      'Analyse des traits du visage et génération du résultat';

  @override
  String get generationComplete => 'Terminé ! Enregistré dans vos créations.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Échec du chargement des vidéos : $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Échec du chargement des photos : $error';
  }

  @override
  String get filterVideo => 'Vidéo';

  @override
  String get filterPhoto => 'Photo';

  @override
  String get workFilesAvailable =>
      'Fichiers disponibles uniquement 7 jours — enregistrer maintenant';

  @override
  String get workGenerationFailed =>
      'Génération échouée. Veuillez remplacer la photo et réessayer.';

  @override
  String get workWaiting => 'Attente prévue de 30 minutes…';

  @override
  String get creationCompleted => 'Création terminée';

  @override
  String get taskSubmission => 'Soumission de tâche';

  @override
  String get completed => 'Terminé';

  @override
  String get generationFailed => 'Génération échouée';

  @override
  String generationOnTheWay(String title) {
    return 'Votre $title est en chemin 🍼';
  }

  @override
  String get generationWaitMsg => 'Cela peut prendre environ 1 à 2 minutes.';

  @override
  String get somethingWentWrong =>
      'Une erreur s\'est produite.\nVeuillez réessayer.';

  @override
  String get viewNow => 'Voir maintenant';

  @override
  String get goBack => 'Retour';

  @override
  String get buyPoints => '✦ Acheter des points';

  @override
  String get submittingWait => 'Envoi en cours, veuillez patienter…';

  @override
  String get myPhoto => 'Ma photo';

  @override
  String get mothersPhoto => 'Photo de la mère';

  @override
  String get fathersPhoto => 'Photo du père';

  @override
  String get detectSimilarity => 'Détecter la similarité';

  @override
  String get babyPhotoLabel => 'Photo du bébé';

  @override
  String get gender => 'Genre';

  @override
  String get skinTone => 'Teint de peau';

  @override
  String get ultrasoundPhoto => 'Photo d\'échographie';

  @override
  String get viewYourBaby => 'Voir votre bébé';

  @override
  String get familyStyle => 'Style familial';

  @override
  String get generateFamilyPortrait => 'Générer un portrait de famille';

  @override
  String get photoGuidanceGood =>
      'Inclure les épaules, des arrière-plans variés, des vêtements, des émotions et des angles de tête.';

  @override
  String get photoGuidanceBad =>
      'Éviter les visages couverts, les lunettes de soleil, les photos de groupe ou le maquillage lourd.';

  @override
  String get takeSelfie => 'Prendre un selfie';

  @override
  String get selectPhoto => 'Sélectionner une photo';
}
