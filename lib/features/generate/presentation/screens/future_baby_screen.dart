import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_shared.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:go_router/go_router.dart';

class FutureBabyScreen extends StatefulWidget {
  const FutureBabyScreen({super.key});

  @override
  State<FutureBabyScreen> createState() => _FutureBabyScreenState();
}

class _FutureBabyScreenState extends State<FutureBabyScreen> {
  int _selectedGender = 0;
  String? _momPath;
  String? _dadPath;

  static const _genderAssets = [
    'assets/images/img_gender_baby_girl.png',
    'assets/images/img_gender_baby_boy.png',
    'assets/images/img_gender_teen_girl.png',
    'assets/images/img_gender_teen_boy.png',
  ];

  static const _prompts = [
    '1-year-old baby girl',
    '1-year-old baby boy',
    '8-year-old girl',
    '8-year-old boy',
  ];

  void _generate() {
    context.push(AppRoute.generating, extra: {
      'featureTitle': 'future baby',
      'momPath': _momPath!,
      'dadPath': _dadPath!,
      'prompt': _prompts[_selectedGender],
    });
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate = _momPath != null && _dadPath != null;
    final l10n = context.l10n;
    final genderLabels = [l10n.babyGirl, l10n.babyBoy, l10n.teenGirl, l10n.teenBoy];
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppMetrics.spaceS),
                    // Two parent pickers with bold labels above
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LabeledPicker(
                            label: l10n.momsPhoto,
                            pickedPath: _momPath,
                            onDelete: () => setState(() => _momPath = null),
                            onTap: () async {
                              final path = await context.push<String?>(
                                AppRoute.photoUploadReminder,
                              );
                              if (path != null && mounted) {
                                setState(() => _momPath = path);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppMetrics.spaceM),
                        Expanded(
                          child: LabeledPicker(
                            label: l10n.dadsPhoto,
                            pickedPath: _dadPath,
                            onDelete: () => setState(() => _dadPath = null),
                            onTap: () async {
                              final path = await context.push<String?>(
                                AppRoute.photoUploadReminder,
                              );
                              if (path != null && mounted) {
                                setState(() => _dadPath = path);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    // Curved bracket arrow
                    const CurveArrow(),
                    // "Boy or Girl" heading
                    Text(
                      l10n.boyOrGirl,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    // Gender cards
                    SizedBox(
                      height: 148,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _genderAssets.length,
                        itemBuilder: (context, i) {
                          final selected = _selectedGender == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedGender = i),
                            child: Container(
                              width: 112,
                              margin: EdgeInsets.only(
                                right: i < _genderAssets.length - 1
                                    ? AppMetrics.spaceS
                                    : 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppMetrics.radiusM),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppMetrics.radiusM - 3),
                                child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    _genderAssets[i],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: AppColors.surfaceVariant,
                                      child: const Icon(
                                        Icons.child_care,
                                        size: 48,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black54,
                                          ],
                                        ),
                                      ),
                                      child: Text(
                                        genderLabels[i],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        },
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    Text(
                      l10n.uploadPhotoHint,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppMetrics.spaceXl),
                  ],
                ),
              ),
            ),
            // Pinned bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.screenPaddingHorizontal,
                8,
                AppMetrics.screenPaddingHorizontal,
                20,
              ),
              child: GradientCtaButton(
                key: const ValueKey('btn_future_baby_generate'),
                label: l10n.generateBabyPhoto,
                points: 3,
                enabled: canGenerate,
                onTap: _generate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
