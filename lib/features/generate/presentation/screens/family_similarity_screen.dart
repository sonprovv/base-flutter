import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_shared.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:go_router/go_router.dart';

class FamilySimilarityScreen extends StatefulWidget {
  const FamilySimilarityScreen({super.key});

  @override
  State<FamilySimilarityScreen> createState() => _FamilySimilarityScreenState();
}

class _FamilySimilarityScreenState extends State<FamilySimilarityScreen> {
  String? _motherPath;
  String? _fatherPath;
  String? _babyPath;

  void _generate() {
    context.push(AppRoute.generating, extra: {
      'featureTitle': 'family similarity',
      'momPath': _motherPath!,
      'dadPath': _fatherPath!,
      'prompt': 'family similarity analysis with baby photo',
    });
  }

  @override
  Widget build(BuildContext context) {
    final canDetect = _motherPath != null && _fatherPath != null && _babyPath != null;
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LabeledPicker(
                            label: context.l10n.mothersPhoto,
                            pickedPath: _motherPath,
                            onDelete: () => setState(() => _motherPath = null),
                            onTap: () async {
                              final path = await context.push<String?>(
                                AppRoute.photoUploadReminder,
                              );
                              if (path != null && mounted) {
                                setState(() => _motherPath = path);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppMetrics.spaceM),
                        Expanded(
                          child: LabeledPicker(
                            label: context.l10n.fathersPhoto,
                            pickedPath: _fatherPath,
                            onDelete: () => setState(() => _fatherPath = null),
                            onTap: () async {
                              final path = await context.push<String?>(
                                AppRoute.photoUploadReminder,
                              );
                              if (path != null && mounted) {
                                setState(() => _fatherPath = path);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const CurveArrow(),
                    Text(
                      context.l10n.babyPhotoLabel,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    LargePicker(
                      pickedPath: _babyPath,
                      onDelete: () => setState(() => _babyPath = null),
                      onTap: () async {
                        final path = await context.push<String?>(
                          AppRoute.photoUploadReminder,
                        );
                        if (path != null && mounted) {
                          setState(() => _babyPath = path);
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
                key: const ValueKey('btn_similarity_detect'),
                label: context.l10n.detectSimilarity,
                points: 3,
                enabled: canDetect,
                onTap: _generate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
