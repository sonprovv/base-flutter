import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/photo_picker_widget.dart';

class FutureBabyScreen extends StatefulWidget {
  const FutureBabyScreen({super.key});

  @override
  State<FutureBabyScreen> createState() => _FutureBabyScreenState();
}

class _FutureBabyScreenState extends State<FutureBabyScreen> {
  int _selectedGender = 0;
  static const _genderOptions = [
    (id: 'girl', label: 'Baby Girl', asset: 'assets/images/img_gender_baby_girl.png'),
    (id: 'boy', label: 'Baby Boy', asset: 'assets/images/img_gender_baby_boy.png'),
    (id: 'teen_girl', label: 'Teen Girl', asset: 'assets/images/img_gender_teen_girl.png'),
    (id: 'teen_boy', label: 'Teen Boy', asset: 'assets/images/img_gender_teen_boy.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.onBackground),
        title: const Text(
          'Future Baby',
          style: TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload photos to see your future baby',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceL),
              // Photo pickers
              Row(
                children: [
                  Expanded(
                    child: PhotoPickerWidget(
                      key: const ValueKey('picker_future_baby_dad'),
                      label: 'Father',
                      icon: Icons.face,
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: AppMetrics.spaceM),
                  Expanded(
                    child: PhotoPickerWidget(
                      key: const ValueKey('picker_future_baby_mom'),
                      label: 'Mother',
                      icon: Icons.face_3,
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppMetrics.spaceL),
              // Gender selector
              const Text(
                'Baby Gender',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceM),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _genderOptions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppMetrics.spaceM),
                  itemBuilder: (context, i) {
                    final option = _genderOptions[i];
                    final selected = _selectedGender == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedGender = i),
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.all(AppMetrics.spaceS),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary.withAlpha(25) : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppMetrics.radiusM),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.outline,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              option.asset,
                              width: 48,
                              height: 48,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.face,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              option.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                color: selected ? AppColors.primary : AppColors.onBackground,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppMetrics.spaceXl),
              GradientCtaButton(
                key: const ValueKey('btn_future_baby_generate'),
                label: 'Generate',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }
}
