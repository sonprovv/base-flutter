import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.onBackground),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          _SettingsSection(
            title: 'General',
            items: [
              _SettingsItem(
                icon: Icons.language,
                label: 'Language',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsItem(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
          _SettingsSection(
            title: 'Account',
            items: [
              _SettingsItem(
                icon: Icons.restore,
                label: 'Restore Purchases',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsItem(
                icon: Icons.star_outline,
                label: 'Upgrade to PRO',
                onTap: () => _showComingSoon(context),
                trailingColor: AppColors.primary,
              ),
            ],
          ),
          _SettingsSection(
            title: 'About',
            items: [
              _SettingsItem(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsItem(
                icon: Icons.description_outlined,
                label: 'Terms of Service',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsItem(
                icon: Icons.mail_outline,
                label: 'Contact Us',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsItem(
                icon: Icons.star_rate_outlined,
                label: 'Rate App',
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
          const SizedBox(height: AppMetrics.spaceXl),
          Center(
            child: Text(
              'BabyGenie v1.0.0',
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

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }
}

class _SettingsSection extends StatelessWidget {

  const _SettingsSection({required this.title, required this.items});
  final String title;
  final List<_SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.screenPaddingHorizontal,
            AppMetrics.spaceM,
            AppMetrics.screenPaddingHorizontal,
            AppMetrics.spaceXs,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppMetrics.screenPaddingHorizontal,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppMetrics.radiusM),
          ),
          child: Column(
            children: items
                .asMap()
                .entries
                .map((entry) => Column(
                      children: [
                        entry.value,
                        if (entry.key < items.length - 1)
                          const Divider(
                            height: 1,
                            indent: 52,
                            color: AppColors.outline,
                          ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingColor,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? trailingColor;

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
            Icon(icon, color: AppColors.onBackground, size: 20),
            const SizedBox(width: AppMetrics.spaceM),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color:
                      trailingColor ?? AppColors.onBackground,
                  fontWeight: trailingColor != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: trailingColor ?? AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
