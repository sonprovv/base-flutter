import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_result_dialog.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_shared.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:go_router/go_router.dart';

class UltrasoundViewerScreen extends StatefulWidget {
  const UltrasoundViewerScreen({super.key});

  @override
  State<UltrasoundViewerScreen> createState() => _UltrasoundViewerScreenState();
}

class _UltrasoundViewerScreenState extends State<UltrasoundViewerScreen> {
  // 0 = Baby Girl, 1 = Baby Boy (matches reference order)
  int _selectedGender = 0;
  int _selectedSkinTone = 0;
  String? _photoPath;

  static const _skinTones = [
    AppColors.skinTone1,
    AppColors.skinTone2,
    AppColors.skinTone3,
    AppColors.skinTone4,
  ];

  void _generate() {
    final resultAsset = _selectedGender == 0
        ? 'assets/images/img_gender_baby_girl.png'
        : 'assets/images/img_gender_baby_boy.png';
    unawaited(
      GenerateResultDialog.show(
        context,
        featureTitle: 'Ultrasound Viewer',
        resultAsset: resultAsset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const GenHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMetrics.screenPaddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppMetrics.spaceM),
                    // Gender section
                    Text(
                      context.l10n.gender,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    Row(
                      children: [
                        _GenderButton(
                          label: context.l10n.babyGirl,
                          isSelected: _selectedGender == 0,
                          selectedColor: AppColors.genderGirlBorder,
                          onTap: () => setState(() => _selectedGender = 0),
                        ),
                        const SizedBox(width: AppMetrics.spaceM),
                        _GenderButton(
                          label: context.l10n.babyBoy,
                          isSelected: _selectedGender == 1,
                          selectedColor: const Color(0xFF90CAF9),
                          onTap: () => setState(() => _selectedGender = 1),
                        ),
                      ],
                    ),
                    const DashedDivider(),
                    // Skin Tone section
                    Text(
                      context.l10n.skinTone,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    Row(
                      children: List.generate(_skinTones.length, (i) {
                        final selected = _selectedSkinTone == i;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedSkinTone = i),
                          child: Container(
                            width: 44,
                            height: 44,
                            margin: const EdgeInsets.only(
                                right: AppMetrics.spaceM),
                            decoration: BoxDecoration(
                              color: _skinTones[i],
                              shape: BoxShape.circle,
                              border: selected
                                  ? Border.all(
                                      color: AppColors.primary,
                                      width: 3,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ),
                    const DashedDivider(),
                    // Ultrasound Photo section
                    Text(
                      context.l10n.ultrasoundPhoto,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    LargePicker(
                      pickedPath: _photoPath,
                      onDelete: () => setState(() => _photoPath = null),
                      onTap: () async {
                        final path = await context.push<String?>(
                          AppRoute.photoUploadReminder,
                        );
                        if (path != null && mounted) {
                          setState(() => _photoPath = path);
                        }
                      },
                    ),
                    const SizedBox(height: AppMetrics.spaceXl),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.screenPaddingHorizontal,
                8,
                AppMetrics.screenPaddingHorizontal,
                20,
              ),
              child: GradientCtaButton(
                key: const ValueKey('btn_ultrasound_generate'),
                label: context.l10n.viewYourBaby,
                points: 3,
                enabled: _photoPath != null,
                onTap: _generate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppMetrics.spaceM),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor.withAlpha(60)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppMetrics.radiusM),
            border: isSelected
                ? Border.all(color: selectedColor, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? AppColors.onBackground
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
