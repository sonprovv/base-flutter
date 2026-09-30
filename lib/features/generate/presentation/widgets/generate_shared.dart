import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:go_router/go_router.dart';

/// Purple ✦ 0 badge — matches the one in detail screens.
class GenPointsBadge extends StatelessWidget {
  const GenPointsBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoute.paywall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF6C5CE7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(
              '0',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standard header row: back arrow left, badge right.
class GenHeader extends StatelessWidget {
  const GenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.onBackground,
              size: 26,
            ),
            onPressed: () => context.pop(),
          ),
          const Spacer(),
          const GenPointsBadge(),
        ],
      ),
    );
  }
}

/// Bold label above + photo picker box below.
/// When [pickedPath] is non-null, shows the picked image with a delete button.
class LabeledPicker extends StatelessWidget {
  const LabeledPicker({
    super.key,
    required this.label,
    required this.onTap,
    this.pickedPath,
    this.onDelete,
  });
  final String label;
  final VoidCallback onTap;
  final String? pickedPath;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppMetrics.spaceXs),
        pickedPath != null
            ? _PickedPhoto(
                path: pickedPath!,
                height: AppMetrics.generatePickerHeight,
                onDelete: onDelete,
              )
            : GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity,
                  height: AppMetrics.generatePickerHeight,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppMetrics.radiusL),
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
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: AppColors.primary),
                      ),
                      const SizedBox(height: AppMetrics.spaceXs),
                      Text(
                        context.l10n.uploadPhoto,
                        style: const TextStyle(fontSize: 13, color: AppColors.textHint),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}

/// Large single picker with "Tap to select an Image" label inside.
/// When [pickedPath] is non-null, shows the picked image with a delete button.
class LargePicker extends StatelessWidget {
  const LargePicker({
    super.key,
    required this.onTap,
    this.pickedPath,
    this.onDelete,
  });
  final VoidCallback onTap;
  final String? pickedPath;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (pickedPath != null) {
      return _PickedPhoto(
        path: pickedPath!,
        height: 200,
        onDelete: onDelete,
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppMetrics.radiusL),
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
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: AppColors.primary),
            ),
            const SizedBox(height: AppMetrics.spaceXs),
            Text(
              context.l10n.tapToSelectImage,
              style: const TextStyle(fontSize: 13, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

/// Picked photo display: full-bleed image + delete icon at top-right.
class _PickedPhoto extends StatelessWidget {
  const _PickedPhoto({
    required this.path,
    required this.height,
    this.onDelete,
  });
  final String path;
  final double height;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppMetrics.radiusL),
            child: Image.file(
              File(path),
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
          if (onDelete != null)
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: onDelete,
                child: Image.asset(
                  'assets/images/ic_pic_delete.png',
                  width: 28,
                  height: 28,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Curved bracket + downward arrow using the bundled asset.
class CurveArrow extends StatelessWidget {
  const CurveArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.spaceS),
      child: Image.asset(
        'assets/images/ic_pic_arrow_down.png',
        height: 56,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Dashed horizontal divider used in UltrasoundViewerScreen.
class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.spaceM),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashW = 6.0;
          const gap = 4.0;
          final count = (constraints.maxWidth / (dashW + gap)).floor();
          return Row(
            children: List.generate(count, (_) => Container(
              width: dashW,
              height: 1,
              margin: const EdgeInsets.only(right: gap),
              color: AppColors.outline,
            )),
          );
        },
      ),
    );
  }
}
