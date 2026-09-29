import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';

class GradientCtaButton extends StatelessWidget {

  const GradientCtaButton({
    super.key,
    required this.label,
    this.points,
    this.onTap,
    this.enabled = true,
  });
  final String label;
  final int? points;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: AppMetrics.buttonHeight,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                )
              : null,
          color: enabled ? null : AppColors.outline,
          borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (points != null)
              Positioned(
                right: AppMetrics.spaceXl,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: AppColors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$points',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
