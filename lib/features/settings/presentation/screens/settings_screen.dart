import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/rate_app_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _privacyPolicyUrl = 'https://babygenie.app/privacy-policy';
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.babygenie.app';
  static const _shareText = 'Check out BabyGenie – the best baby photo generator app!\nhttps://play.google.com/store/apps/details?id=com.babygenie.app';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.onBackground),
        title: Text(
          context.l10n.settingsTitle,
          style: const TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: AppMetrics.spaceS),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppMetrics.screenPaddingHorizontal,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppMetrics.radiusM),
            ),
            child: Column(
              children: [
                _SettingsItem(
                  leadingIcon: const Icon(Icons.language, color: AppColors.onBackground, size: 20),
                  label: context.l10n.settingsLanguage,
                  onTap: () => context.push(AppRoute.language),
                ),
                const Divider(height: 1, indent: 52, color: AppColors.outline),
                _SettingsItem(
                  leadingIcon: Image.asset(
                    'assets/images/icon_me_privacy.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.privacy_tip_outlined, color: AppColors.onBackground, size: 20),
                  ),
                  label: context.l10n.settingsPrivacyPolicy,
                  onTap: () => _openUrl(_privacyPolicyUrl),
                ),
                const Divider(height: 1, indent: 52, color: AppColors.outline),
                _SettingsItem(
                  leadingIcon: Image.asset(
                    'assets/images/ic_start_mid.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.star_rate_outlined, color: AppColors.onBackground, size: 20),
                  ),
                  label: context.l10n.settingsRateApp,
                  onTap: () => RateAppDialog.show(context, playStoreUrl: _playStoreUrl),
                ),
                const Divider(height: 1, indent: 52, color: AppColors.outline),
                _SettingsItem(
                  leadingIcon: const Icon(Icons.share_outlined, color: AppColors.onBackground, size: 20),
                  label: context.l10n.settingsShareApp,
                  onTap: () => SharePlus.instance.share(ShareParams(text: _shareText)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppMetrics.spaceXl),
          Center(
            child: Text(
              context.l10n.appVersion,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppMetrics.spaceM),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.leadingIcon,
    required this.label,
    required this.onTap,
  });
  final Widget leadingIcon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppMetrics.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMetrics.spaceM,
          vertical: AppMetrics.spaceM,
        ),
        child: Row(
          children: [
            SizedBox(width: 20, height: 20, child: leadingIcon),
            const SizedBox(width: AppMetrics.spaceM),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.onBackground,
                ),
              ),
            ),
            Image.asset(
              'assets/images/icon_right_arrow_gray.png',
              width: 14,
              height: 14,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
