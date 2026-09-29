import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _LangOption {

  const _LangOption(this.code, this.name, this.flag);
  final String code;
  final String name;
  final String flag;
}

const _languages = [
  _LangOption('en', 'English', '🇺🇸'),
  _LangOption('ar', 'Arabic', '🇸🇦'),
  _LangOption('hi', 'Hindi', '🇮🇳'),
  _LangOption('es', 'Spanish', '🇪🇸'),
  _LangOption('zh', 'Chinese', '🇨🇳'),
  _LangOption('pt', 'Portuguese', '🇧🇷'),
  _LangOption('de', 'Germany', '🇩🇪'),
  _LangOption('ru', 'Russian', '🇷🇺'),
  _LangOption('id', 'Indonesian', '🇮🇩'),
  _LangOption('fr', 'French', '🇫🇷'),
  _LangOption('vi', 'Vietnamese', '🇻🇳'),
];

class LanguageScreen extends ConsumerStatefulWidget {

  const LanguageScreen({super.key, this.fromSplash = false});
  final bool fromSplash;

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  String? _selected;

  void _onSelect(String code) {
    setState(() => _selected = code);
  }

  void _onSave() {
    if (_selected == null) return;
    final prefs = ref.read(prefsServiceProvider);
    prefs.selectedLanguage = _selected!;
    if (prefs.isCompletedOnboarding && !prefs.isSecondOpen) {
      context.go(AppRoute.main);
    } else {
      context.go(AppRoute.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.read(prefsServiceProvider);
    _selected ??= prefs.selectedLanguage;

    return Scaffold(
      backgroundColor: AppColors.primaryContainer,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppMetrics.screenPaddingHorizontal,
                vertical: AppMetrics.spaceM,
              ),
              child: Row(
                children: [
                  if (!widget.fromSplash)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                  const Expanded(
                    child: Text(
                      'Choose Language',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (_selected != null)
                    TextButton(
                      onPressed: _onSave,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMetrics.screenPaddingHorizontal,
                ),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = _selected == lang.code;
                  return _LangItem(
                    lang: lang,
                    isSelected: isSelected,
                    onTap: () => _onSelect(lang.code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangItem extends StatelessWidget {

  const _LangItem({
    required this.lang,
    required this.isSelected,
    required this.onTap,
  });
  final _LangOption lang;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppMetrics.languageItemHeight,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppMetrics.radiusCard),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppMetrics.spaceM),
        child: Row(
          children: [
            Text(
              lang.flag,
              style: const TextStyle(fontSize: 26),
            ),
            const SizedBox(width: AppMetrics.spaceM),
            Expanded(
              child: Text(
                lang.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Radio<String>(
              value: lang.code,
              groupValue: isSelected ? lang.code : null,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
