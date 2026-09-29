import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/photo_picker_widget.dart';

class FutureFamilyScreen extends StatelessWidget {
  const FutureFamilyScreen({super.key});

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
          'Future Family',
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
                'Upload photos to see your future family portrait',
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
                      key: const ValueKey('picker_future_family_person1'),
                      label: 'Person 1',
                      icon: Icons.face,
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                  const SizedBox(width: AppMetrics.spaceM),
                  Expanded(
                    child: PhotoPickerWidget(
                      key: const ValueKey('picker_future_family_person2'),
                      label: 'Person 2',
                      icon: Icons.face_3,
                      onTap: () => _showComingSoon(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppMetrics.spaceXl),
              GradientCtaButton(
                key: const ValueKey('btn_future_family_generate'),
                label: 'Generate Family Portrait',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
