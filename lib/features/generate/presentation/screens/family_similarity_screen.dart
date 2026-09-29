import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/photo_picker_widget.dart';

class FamilySimilarityScreen extends StatelessWidget {
  const FamilySimilarityScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.onBackground),
        title: const Text(
          'Family Similarity',
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
                'Upload photos to detect family resemblance',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceL),
              Row(
                children: [
                  Expanded(
                    child: PhotoPickerWidget(
                      key: const ValueKey('picker_similarity_mother'),
                      label: 'Mother',
                      icon: Icons.face_3,
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: AppMetrics.spaceXs),
                  Expanded(
                    child: PhotoPickerWidget(
                      key: const ValueKey('picker_similarity_father'),
                      label: 'Father',
                      icon: Icons.face,
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: AppMetrics.spaceXs),
                  Expanded(
                    child: PhotoPickerWidget(
                      key: const ValueKey('picker_similarity_baby'),
                      label: 'Baby',
                      icon: Icons.child_care,
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppMetrics.spaceXl),
              GradientCtaButton(
                key: const ValueKey('btn_similarity_detect'),
                label: 'Detect Similarity',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
