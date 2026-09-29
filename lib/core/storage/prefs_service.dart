import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {

  PrefsService(this._prefs);
  final SharedPreferences _prefs;

  static const _keyOpenCount = 'open_count';
  static const _keyCompletedOnboarding = 'completed_onboarding';
  static const _keySelectedLanguage = 'selected_language';

  int get openCount => _prefs.getInt(_keyOpenCount) ?? 0;
  set openCount(int v) => _prefs.setInt(_keyOpenCount, v);

  bool get isCompletedOnboarding => _prefs.getBool(_keyCompletedOnboarding) ?? false;
  set isCompletedOnboarding(bool v) => _prefs.setBool(_keyCompletedOnboarding, v);

  bool get isSecondOpen => openCount == 2;

  String get selectedLanguage => _prefs.getString(_keySelectedLanguage) ?? 'en';
  set selectedLanguage(String v) => _prefs.setString(_keySelectedLanguage, v);
}

final prefsServiceProvider = Provider<PrefsService>((ref) {
  throw StateError('prefsServiceProvider must be overridden in bootstrap().');
});
