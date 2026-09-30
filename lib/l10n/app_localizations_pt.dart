// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppL10nPt extends AppL10n {
  AppL10nPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Crie momentos mágicos para o seu bebê';

  @override
  String get splashAdDisclaimer => 'Esta ação pode conter anúncios';

  @override
  String get chooseLanguage => 'Escolher idioma';

  @override
  String get save => 'Salvar';

  @override
  String get onboarding1Title => 'Descubra seu\nBebê do Futuro';

  @override
  String get onboarding1Desc =>
      'Veja como será seu bebê com geração de rostos por IA';

  @override
  String get onboarding2Title => 'Templates de\nDança do Bebê';

  @override
  String get onboarding2Desc =>
      'Crie vídeos de dança adoraveis com seu bebê usando templates em alta';

  @override
  String get onboarding3Title => 'Similaridade\nFamiliar';

  @override
  String get onboarding3Desc =>
      'Descubra com quem seu bebê mais se parece com nossa detecção de similaridade';

  @override
  String get next => 'Próximo';

  @override
  String get getStarted => 'Começar';

  @override
  String get termsAgreement =>
      'Ao continuar, você concorda com nossos Termos e Política de Privacidade';

  @override
  String get navHome => 'Início';

  @override
  String get navVideo => 'Vídeo';

  @override
  String get navPhoto => 'Foto';

  @override
  String get navProfile => 'Perfil';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get comingSoon => 'Em breve!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get error => 'Erro';

  @override
  String get homeLoadError => 'Falha ao carregar início';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileUser => 'Usuário BabyGenie';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString criações';
  }

  @override
  String get filterAll => 'Todos';

  @override
  String get noCreationsYet => 'Nenhuma criação ainda';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidade';

  @override
  String get settingsRateApp => 'Avaliar App';

  @override
  String get settingsShareApp => 'Compartilhar App';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Foto da Mãe';

  @override
  String get dadsPhoto => 'Foto do Pai';

  @override
  String get babysPhoto => 'Foto do Bebê';

  @override
  String get boyOrGirl => 'Menino ou Menina';

  @override
  String get uploadPhotoHint =>
      'Envie fotos claras de frente para melhores resultados';

  @override
  String get generateBabyPhoto => 'Gerar Foto do Bebê';

  @override
  String get uploadPhoto => 'Enviar Foto';

  @override
  String get tapToSelectImage => 'Toque para selecionar uma imagem';

  @override
  String get babyGirl => 'Bebê Menina';

  @override
  String get babyBoy => 'Bebê Menino';

  @override
  String get teenGirl => 'Adolescente Menina';

  @override
  String get teenBoy => 'Adolescente Menino';

  @override
  String get noTemplatesFound => 'Nenhum template encontrado';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Desbloqueie todos os recursos premium';

  @override
  String get paywallTrial => 'TESTE';

  @override
  String get paywallContinue => 'Continuar';

  @override
  String get paywallCancelNote =>
      'Cancele a qualquer momento · Restaurar compras';

  @override
  String get uninstallSorry =>
      'Sentimos muito se não atendemos às suas expectativas.';

  @override
  String get uninstallImprove => 'Por favor, diga-nos como podemos melhorar.';

  @override
  String get uninstallNotUseful =>
      'Não muito mais útil do que o recurso padrão';

  @override
  String get uninstallLaggy => 'Lento ou sem resposta';

  @override
  String get explore => 'Explorar';

  @override
  String get dontUninstall => 'Não desinstalar ainda';

  @override
  String get stillUninstall => 'Ainda quero desinstalar';

  @override
  String get whyUninstall => 'Por que você desinstalou o app?';

  @override
  String get uninstall => 'Desinstalar';

  @override
  String get uninstallReasonDifficult => 'Difícil de usar';

  @override
  String get uninstallReasonAds => 'Muitos anúncios';

  @override
  String get uninstallReasonError => 'Erro, não está funcionando';

  @override
  String get uninstallReasonBattery => 'Consumo rápido de bateria';

  @override
  String get uninstallReasonOthers => 'Outros';

  @override
  String get uninstallConfirmTitle => 'Tem certeza?';

  @override
  String get uninstallConfirmContent => 'Deseja desinstalar este app?';

  @override
  String get skip => 'Pular';

  @override
  String get bornBaby => 'Bebê nascido';

  @override
  String get unbornBaby => 'Bebê por nascer';

  @override
  String get createNow => 'Criar agora';

  @override
  String get generatingAiBaby => 'Gerando foto de bebê IA...';

  @override
  String get analyzingFacialFeatures =>
      'Analisando características faciais e gerando resultado';

  @override
  String get generationComplete => 'Concluído! Salvo em suas criações.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Falha ao carregar vídeos: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Falha ao carregar fotos: $error';
  }

  @override
  String get filterVideo => 'Vídeo';

  @override
  String get filterPhoto => 'Foto';

  @override
  String get workFilesAvailable =>
      'Arquivos disponíveis por apenas 7 dias — salvar agora';

  @override
  String get workGenerationFailed =>
      'Geração falhou. Substitua a foto e tente novamente.';

  @override
  String get workWaiting => 'Espera prevista de 30 minutos…';

  @override
  String get creationCompleted => 'Criação concluída';

  @override
  String get taskSubmission => 'Enviando tarefa';

  @override
  String get completed => 'Concluído';

  @override
  String get generationFailed => 'Geração falhou';

  @override
  String generationOnTheWay(String title) {
    return 'Seu $title está a caminho 🍼';
  }

  @override
  String get generationWaitMsg => 'Isso pode levar cerca de 1-2 minutos.';

  @override
  String get somethingWentWrong =>
      'Algo deu errado.\nPor favor, tente novamente.';

  @override
  String get viewNow => 'Ver agora';

  @override
  String get goBack => 'Voltar';

  @override
  String get buyPoints => '✦ Comprar pontos';

  @override
  String get submittingWait => 'Enviando, aguarde…';

  @override
  String get myPhoto => 'Minha foto';

  @override
  String get mothersPhoto => 'Foto da mãe';

  @override
  String get fathersPhoto => 'Foto do pai';

  @override
  String get detectSimilarity => 'Detectar semelhança';

  @override
  String get babyPhotoLabel => 'Foto do bebê';

  @override
  String get gender => 'Gênero';

  @override
  String get skinTone => 'Tom de pele';

  @override
  String get ultrasoundPhoto => 'Foto de ultrassom';

  @override
  String get viewYourBaby => 'Ver seu bebê';

  @override
  String get familyStyle => 'Estilo familiar';

  @override
  String get generateFamilyPortrait => 'Gerar retrato familiar';

  @override
  String get photoGuidanceGood =>
      'Inclua ombros, fundos variados, roupas, emoções e ângulos da cabeça.';

  @override
  String get photoGuidanceBad =>
      'Evite rostos cobertos, óculos de sol, fotos em grupo ou maquiagem pesada.';

  @override
  String get takeSelfie => 'Tirar uma selfie';

  @override
  String get selectPhoto => 'Selecionar foto';
}
