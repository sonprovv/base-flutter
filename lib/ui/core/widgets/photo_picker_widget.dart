import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';

class PhotoPickerWidget extends StatelessWidget {

  const PhotoPickerWidget({super.key, this.label, this.icon, this.onTap});
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: AppMetrics.generatePickerHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppMetrics.radiusL),
          border: Border.all(color: AppColors.outline, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppMetrics.generatePickerAddCircle,
              height: AppMetrics.generatePickerAddCircle,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Icon(
                icon ?? Icons.add,
                color: AppColors.primary,
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: AppMetrics.spaceXs),
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textHint,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
