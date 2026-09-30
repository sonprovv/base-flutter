import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_result_dialog.dart';
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

  static const _genderOptions = [
    (
      title: 'Baby Girl',
      icon: 'assets/images/ic_baby_girl.png',
      resultAsset: 'assets/images/img_gender_baby_girl.png',
      prompt: 'The child is a 1-year-old girl',
    ),
    (
      title: 'Baby Boy',
      icon: 'assets/images/ic_baby_boy.png',
      resultAsset: 'assets/images/img_gender_baby_boy.png',
      prompt: 'The child is a 1-year-old boy.',
    ),
    (
      title: 'Teen Girl',
      icon: 'assets/images/ic_teen_girl.png',
      resultAsset: 'assets/images/img_gender_teen_girl.png',
      prompt: 'The child is a 8-year-old girl',
    ),
    (
      title: 'Teen Boy',
      icon: 'assets/images/ic_teen_boy.png',
      resultAsset: 'assets/images/img_gender_teen_boy.png',
      prompt: 'The child is a 8-year-old boy',
    ),
  ];

  void _generate() {
    final selected = _genderOptions[_selectedGender];
    unawaited(
      GenerateResultDialog.show(
        context,
        featureTitle: 'Future Baby',
        resultAsset: selected.resultAsset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate = _momPath != null && _dadPath != null;
    final l10n = context.l10n;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = ((screenWidth - 30 - 24) / 2.8).clamp(108.0, 132.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const GenHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    // Two parent pickers
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LabeledPicker(
                            label: l10n.momsPhoto,
                            pickedPath: _momPath,
                            height: 150,
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: LabeledPicker(
                            label: l10n.dadsPhoto,
                            pickedPath: _dadPath,
                            height: 150,
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
                    const CurveArrow(),
                    // "Boy or Girl" heading
                    Text(
                      l10n.boyOrGirl,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF181A1F),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Horizontal gender carousel
                    SizedBox(
                      height: 144,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: _genderOptions.length,
                        itemBuilder: (context, i) {
                          final item = _genderOptions[i];
                          final isSelected = _selectedGender == i;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: i < _genderOptions.length - 1 ? 10 : 0,
                            ),
                            child: _GenderCard(
                              width: cardWidth,
                              title: item.title,
                              iconAsset: item.icon,
                              isSelected: isSelected,
                              onTap: () => setState(() => _selectedGender = i),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.uploadPhotoHint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8F8F8F),
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Pinned bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
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

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.width,
    required this.title,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  final double width;
  final String title;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6A67FF) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0x336A67FF)
                  : Colors.black.withAlpha(8),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    iconAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(
                        Icons.child_care,
                        size: 42,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 3,
                left: 3,
                right: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(9),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(160),
                      ],
                    ),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
