// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppL10nEs extends AppL10n {
  AppL10nEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Crea momentos mágicos para tu bebé';

  @override
  String get splashAdDisclaimer => 'Esta acción puede contener anuncios';

  @override
  String get chooseLanguage => 'Elegir idioma';

  @override
  String get save => 'Guardar';

  @override
  String get onboarding1Title => 'Descubre tu\nBebé Futuro';

  @override
  String get onboarding1Desc =>
      'Mira cómo será tu bebé con generación de rostros con IA';

  @override
  String get onboarding2Title => 'Plantillas de\nBaile para Bebé';

  @override
  String get onboarding2Desc =>
      'Crea adorables videos de baile con tu bebé usando plantillas de tendencia';

  @override
  String get onboarding3Title => 'Similitud\nFamiliar';

  @override
  String get onboarding3Desc =>
      'Descubre a quién se parece más tu bebé con nuestra detección de similitud';

  @override
  String get next => 'Siguiente';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get termsAgreement =>
      'Al continuar, aceptas nuestros Términos y Política de Privacidad';

  @override
  String get navHome => 'Inicio';

  @override
  String get navVideo => 'Video';

  @override
  String get navPhoto => 'Foto';

  @override
  String get navProfile => 'Perfil';

  @override
  String get retry => 'Reintentar';

  @override
  String get comingSoon => '¡Próximamente!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get error => 'Error';

  @override
  String get homeLoadError => 'Error al cargar inicio';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileUser => 'Usuario BabyGenie';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString creaciones';
  }

  @override
  String get filterAll => 'Todo';

  @override
  String get noCreationsYet => 'Aún no hay creaciones';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidad';

  @override
  String get settingsRateApp => 'Calificar App';

  @override
  String get settingsShareApp => 'Compartir App';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Foto de Mamá';

  @override
  String get dadsPhoto => 'Foto de Papá';

  @override
  String get babysPhoto => 'Foto del Bebé';

  @override
  String get boyOrGirl => 'Niño o Niña';

  @override
  String get uploadPhotoHint =>
      'Sube fotos claras de frente para mejores resultados';

  @override
  String get generateBabyPhoto => 'Generar Foto de Bebé';

  @override
  String get uploadPhoto => 'Subir Foto';

  @override
  String get tapToSelectImage => 'Toca para seleccionar una imagen';

  @override
  String get babyGirl => 'Niña Bebé';

  @override
  String get babyBoy => 'Niño Bebé';

  @override
  String get teenGirl => 'Adolescente Chica';

  @override
  String get teenBoy => 'Adolescente Chico';

  @override
  String get noTemplatesFound => 'No se encontraron plantillas';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Desbloquea todas las funciones premium';

  @override
  String get paywallTrial => 'PRUEBA';

  @override
  String get paywallContinue => 'Continuar';

  @override
  String get paywallCancelNote =>
      'Cancela en cualquier momento · Restaurar compras';

  @override
  String get uninstallSorry =>
      'Realmente lo sentimos si no cumplimos con tus expectativas.';

  @override
  String get uninstallImprove => 'Por favor, dínos cómo podemos mejorar.';

  @override
  String get uninstallNotUseful =>
      'No mucho más útil que la función predeterminada';

  @override
  String get uninstallLaggy => 'Lento o sin respuesta';

  @override
  String get explore => 'Explorar';

  @override
  String get dontUninstall => 'No desinstalar aún';

  @override
  String get stillUninstall => 'Aún quiero desinstalar';

  @override
  String get whyUninstall => '¿Por qué desinstalaste la app?';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String get uninstallReasonDifficult => 'Difícil de usar';

  @override
  String get uninstallReasonAds => 'Demasiados anuncios';

  @override
  String get uninstallReasonError => 'Error, no funciona';

  @override
  String get uninstallReasonBattery => 'Drenaje rápido de batería';

  @override
  String get uninstallReasonOthers => 'Otros';

  @override
  String get uninstallConfirmTitle => '¿Estás seguro?';

  @override
  String get uninstallConfirmContent => '¿Quieres desinstalar esta app?';

  @override
  String get skip => 'Omitir';

  @override
  String get bornBaby => 'Bebé nacido';

  @override
  String get unbornBaby => 'Bebé por nacer';

  @override
  String get createNow => 'Crear ahora';

  @override
  String get generatingAiBaby => 'Generando foto de bebé IA...';

  @override
  String get analyzingFacialFeatures =>
      'Analizando características faciales y generando resultado';

  @override
  String get generationComplete => '¡Completado! Guardado en tus creaciones.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Error al cargar videos: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Error al cargar fotos: $error';
  }

  @override
  String get filterVideo => 'Video';

  @override
  String get filterPhoto => 'Foto';

  @override
  String get workFilesAvailable =>
      'Archivos disponibles solo 7 días — guardar ahora';

  @override
  String get workGenerationFailed =>
      'Generación fallida. Reemplaza la foto e inténtalo de nuevo.';

  @override
  String get workWaiting => 'Se espera una espera de 30 minutos…';

  @override
  String get creationCompleted => 'Creación completada';

  @override
  String get taskSubmission => 'Enviando tarea';

  @override
  String get completed => 'Completado';

  @override
  String get generationFailed => 'Generación fallida';

  @override
  String generationOnTheWay(String title) {
    return 'Tu $title está en camino 🍼';
  }

  @override
  String get generationWaitMsg =>
      'Esto puede tardar aproximadamente 1-2 minutos.';

  @override
  String get somethingWentWrong =>
      'Algo salió mal.\nPor favor, inténtalo de nuevo.';

  @override
  String get viewNow => 'Ver ahora';

  @override
  String get goBack => 'Volver';

  @override
  String get buyPoints => '✦ Comprar puntos';

  @override
  String get submittingWait => 'Enviando, por favor espere…';

  @override
  String get myPhoto => 'Mi foto';

  @override
  String get mothersPhoto => 'Foto de mamá';

  @override
  String get fathersPhoto => 'Foto de papá';

  @override
  String get detectSimilarity => 'Detectar similitud';

  @override
  String get babyPhotoLabel => 'Foto del bebé';

  @override
  String get gender => 'Género';

  @override
  String get skinTone => 'Tono de piel';

  @override
  String get ultrasoundPhoto => 'Foto de ultrasonido';

  @override
  String get viewYourBaby => 'Ver tu bebé';

  @override
  String get familyStyle => 'Estilo familiar';

  @override
  String get generateFamilyPortrait => 'Generar retrato familiar';

  @override
  String get photoGuidanceGood =>
      'Incluye hombros, fondos variados, ropa, emociones y ángulos de cabeza.';

  @override
  String get photoGuidanceBad =>
      'Evita caras cubiertas, gafas de sol, fotos grupales o maquillaje intenso.';

  @override
  String get takeSelfie => 'Tomar un selfie';

  @override
  String get selectPhoto => 'Seleccionar foto';
}
