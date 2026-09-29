import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:go_router/go_router.dart';

class UninstallScreen extends StatelessWidget {
  const UninstallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.onBackground),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppMetrics.spaceL),
              const Icon(
                Icons.sentiment_dissatisfied_outlined,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppMetrics.spaceM),
              const Text(
                'We’re truly sorry if we haven’t met your expectations.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppMetrics.spaceS),
              const Text(
                'Please let us know how we can improve.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Explore feature 1
              _RetentionCard(
                title: 'Not much more useful than the default feature',
                actionLabel: 'Explore',
                onTap: () => context.go(AppRoute.main),
              ),
              const SizedBox(height: AppMetrics.spaceM),
              // Explore feature 2
              _RetentionCard(
                title: 'Unresponsive or Laggy',
                actionLabel: 'Explore',
                onTap: () => context.go(AppRoute.main),
              ),
              const Spacer(),
              // Don't uninstall yet CTA
              GradientCtaButton(
                key: const ValueKey('btn_dont_uninstall'),
                label: 'Don’t uninstall yet',
                onTap: () => context.go(AppRoute.main),
              ),
              const SizedBox(height: AppMetrics.spaceM),
              // Still want to uninstall
              Center(
                child: TextButton(
                  key: const ValueKey('btn_still_uninstall'),
                  onPressed: () => context.push(AppRoute.askUninstall),
                  child: const Text(
                    'Still want to uninstall',
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppMetrics.spaceM),
            ],
          ),
        ),
      ),
    );
  }
}

class _RetentionCard extends StatelessWidget {

  const _RetentionCard({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });
  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppMetrics.spaceM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppMetrics.radiusL),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
          ),
          const SizedBox(width: AppMetrics.spaceM),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
              ),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
