import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => Locale(ref.read(prefsServiceProvider).selectedLanguage);

  void set(String languageCode) {
    ref.read(prefsServiceProvider).selectedLanguage = languageCode;
    state = Locale(languageCode);
  }
}
