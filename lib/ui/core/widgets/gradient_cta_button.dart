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
    this.gradient,
    this.disabledColor,
    this.boxShadow,
    this.height,
    this.textStyle,
  });

  final String label;
  final int? points;
  final VoidCallback? onTap;
  final bool enabled;
  final Gradient? gradient;
  final Color? disabledColor;
  final List<BoxShadow>? boxShadow;
  final double? height;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppMetrics.buttonHeight;
    final effectiveGradient = enabled
        ? (gradient ??
            const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ))
        : null;
    final effectiveColor =
        enabled ? null : (disabledColor ?? const Color(0xFFBDBDBD));

    final pointsBadge = points != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: enabled ? AppColors.white : AppColors.white.withValues(alpha: 0.8),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '$points',
                style: TextStyle(
                  color: enabled ? AppColors.white : AppColors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : null;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: effectiveHeight,
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          color: effectiveColor,
          borderRadius: BorderRadius.circular(effectiveHeight / 2),
          boxShadow: enabled ? boxShadow : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            if (pointsBadge != null)
              IgnorePointer(
                child: Opacity(
                  opacity: 0,
                  child: pointsBadge,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: textStyle ??
                          TextStyle(
                            color: enabled
                                ? AppColors.white
                                : AppColors.white.withValues(alpha: 0.8),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            ?pointsBadge,
          ],
        ),
      ),
    );
  }
}
