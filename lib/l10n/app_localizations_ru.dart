// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppL10nRu extends AppL10n {
  AppL10nRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Создавайте волшебные моменты с малышом';

  @override
  String get splashAdDisclaimer => 'Этот контент может содержать рекламу';

  @override
  String get chooseLanguage => 'Выбор языка';

  @override
  String get save => 'Сохранить';

  @override
  String get onboarding1Title => 'Узнайте вашего\nбудущего малыша';

  @override
  String get onboarding1Desc =>
      'Посмотрите, как будет выглядеть ваш ребёнок с помощью AI';

  @override
  String get onboarding2Title => 'Шаблоны\nтанцев малыша';

  @override
  String get onboarding2Desc =>
      'Создавайте милые танцевальные видео с малышом по трендовым шаблонам';

  @override
  String get onboarding3Title => 'Семейное\nСходство';

  @override
  String get onboarding3Desc => 'Узнайте, на кого больше всего похож ваш малыш';

  @override
  String get next => 'Далее';

  @override
  String get getStarted => 'Начать';

  @override
  String get termsAgreement =>
      'Продолжая, вы соглашаетесь с нашими Условиями и Политикой конфиденциальности';

  @override
  String get navHome => 'Главная';

  @override
  String get navVideo => 'Видео';

  @override
  String get navPhoto => 'Фото';

  @override
  String get navProfile => 'Профиль';

  @override
  String get retry => 'Повторить';

  @override
  String get comingSoon => 'Скоро!';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get error => 'Ошибка';

  @override
  String get homeLoadError => 'Не удалось загрузить главную';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileUser => 'Пользователь BabyGenie';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString работ';
  }

  @override
  String get filterAll => 'Все';

  @override
  String get noCreationsYet => 'Пока нет работ';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get settingsRateApp => 'Оценить приложение';

  @override
  String get settingsShareApp => 'Поделиться приложением';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Фото мамы';

  @override
  String get dadsPhoto => 'Фото папы';

  @override
  String get babysPhoto => 'Фото малыша';

  @override
  String get boyOrGirl => 'Мальчик или девочка';

  @override
  String get uploadPhotoHint =>
      'Загрузите чёткие фото анфас для лучших результатов';

  @override
  String get generateBabyPhoto => 'Создать фото малыша';

  @override
  String get uploadPhoto => 'Загрузить фото';

  @override
  String get tapToSelectImage => 'Нажмите для выбора изображения';

  @override
  String get babyGirl => 'Девочка';

  @override
  String get babyBoy => 'Мальчик';

  @override
  String get teenGirl => 'Девушка-подросток';

  @override
  String get teenBoy => 'Юноша-подросток';

  @override
  String get noTemplatesFound => 'Шаблоны не найдены';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Откройте все премиум-функции';

  @override
  String get paywallTrial => 'ПРОБНЫЙ';

  @override
  String get paywallContinue => 'Продолжить';

  @override
  String get paywallCancelNote => 'Отмена в любое время · Восстановить покупки';

  @override
  String get uninstallSorry =>
      'Нам очень жаль, если мы не оправдали ваших ожиданий.';

  @override
  String get uninstallImprove =>
      'Пожалуйста, расскажите, как мы можем улучшиться.';

  @override
  String get uninstallNotUseful => 'Не намного полезнее стандартной функции';

  @override
  String get uninstallLaggy => 'Зависает или не отвечает';

  @override
  String get explore => 'Изучить';

  @override
  String get dontUninstall => 'Пока не удалять';

  @override
  String get stillUninstall => 'Всё равно удалить';

  @override
  String get whyUninstall => 'Почему вы удалили приложение?';

  @override
  String get uninstall => 'Удалить';

  @override
  String get uninstallReasonDifficult => 'Сложно использовать';

  @override
  String get uninstallReasonAds => 'Слишком много рекламы';

  @override
  String get uninstallReasonError => 'Ошибка, не работает';

  @override
  String get uninstallReasonBattery => 'Быстрая разрядка батареи';

  @override
  String get uninstallReasonOthers => 'Другое';

  @override
  String get uninstallConfirmTitle => 'Вы уверены?';

  @override
  String get uninstallConfirmContent => 'Вы хотите удалить это приложение?';

  @override
  String get skip => 'Пропустить';

  @override
  String get bornBaby => 'Рождённый ребёнок';

  @override
  String get unbornBaby => 'Нерождённый ребёнок';

  @override
  String get createNow => 'Создать сейчас';

  @override
  String get generatingAiBaby => 'Генерация фото ребёнка ИИ...';

  @override
  String get analyzingFacialFeatures =>
      'Анализ черт лица и создание результата';

  @override
  String get generationComplete => 'Готово! Сохранено в ваших работах.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Не удалось загрузить видео: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Не удалось загрузить фото: $error';
  }

  @override
  String get filterVideo => 'Видео';

  @override
  String get filterPhoto => 'Фото';

  @override
  String get workFilesAvailable =>
      'Файлы доступны только 7 дней — сохраните сейчас';

  @override
  String get workGenerationFailed =>
      'Генерация не удалась. Замените фото и попробуйте снова.';

  @override
  String get workWaiting => 'Ожидаемое время ожидания 30 минут…';

  @override
  String get creationCompleted => 'Создание завершено';

  @override
  String get taskSubmission => 'Отправка задачи';

  @override
  String get completed => 'Завершено';

  @override
  String get generationFailed => 'Генерация не удалась';

  @override
  String generationOnTheWay(String title) {
    return 'Ваш $title в пути 🍼';
  }

  @override
  String get generationWaitMsg => 'Это может занять около 1-2 минут.';

  @override
  String get somethingWentWrong =>
      'Что-то пошло не так.\nПожалуйста, попробуйте снова.';

  @override
  String get viewNow => 'Посмотреть сейчас';

  @override
  String get goBack => 'Назад';

  @override
  String get buyPoints => '✦ Купить очки';

  @override
  String get submittingWait => 'Отправляется, пожалуйста, подождите…';

  @override
  String get myPhoto => 'Моё фото';

  @override
  String get mothersPhoto => 'Фото мамы';

  @override
  String get fathersPhoto => 'Фото папы';

  @override
  String get detectSimilarity => 'Определить сходство';

  @override
  String get babyPhotoLabel => 'Фото ребёнка';

  @override
  String get gender => 'Пол';

  @override
  String get skinTone => 'Тон кожи';

  @override
  String get ultrasoundPhoto => 'Фото УЗИ';

  @override
  String get viewYourBaby => 'Посмотреть вашего ребёнка';

  @override
  String get familyStyle => 'Семейный стиль';

  @override
  String get generateFamilyPortrait => 'Создать семейный портрет';

  @override
  String get photoGuidanceGood =>
      'Включайте плечи, разные фоны, одежду, эмоции и углы головы.';

  @override
  String get photoGuidanceBad =>
      'Избегайте закрытых лиц, солнцезащитных очков, групповых снимков или яркого макияжа.';

  @override
  String get takeSelfie => 'Сделать селфи';

  @override
  String get selectPhoto => 'Выбрать фото';
}
