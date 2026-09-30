import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/core/services/shortcut_uninstall_service.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AskUninstallScreen extends ConsumerStatefulWidget {
  const AskUninstallScreen({super.key});

  @override
  ConsumerState<AskUninstallScreen> createState() => _AskUninstallScreenState();
}

class _AskUninstallScreenState extends ConsumerState<AskUninstallScreen> {
  int _selectedReason = 0;

  static const _reasons = [
    'Difficult to use',
    'Too many ads',
    'Error Not Working',
    'Fast battery drain',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Why did you uninstall the app?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceL),
              Expanded(
                child: ListView.separated(
                  itemCount: _reasons.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppMetrics.spaceS),
                  itemBuilder: (context, index) {
                    final selected = _selectedReason == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedReason = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppMetrics.spaceM,
                          vertical: AppMetrics.spaceM,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withAlpha(20)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppMetrics.radiusM),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.outline,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: selected ? AppColors.primary : AppColors.textHint,
                            ),
                            const SizedBox(width: AppMetrics.spaceM),
                            Text(
                              _reasons[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    selected ? FontWeight.w600 : FontWeight.normal,
                                color: AppColors.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              GradientCtaButton(
                key: const ValueKey('btn_confirm_uninstall'),
                label: 'Uninstall',
                onTap: () => _confirmUninstall(context),
              ),
              const SizedBox(height: AppMetrics.spaceS),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoute.main),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textHint, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmUninstall(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('You want to uninstall this app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              unawaited(ref.read(shortcutUninstallServiceProvider).openAppSettings());
              context.go(AppRoute.main);
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ));
  }
}
