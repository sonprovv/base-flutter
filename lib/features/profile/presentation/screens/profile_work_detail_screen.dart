import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileWorkDetailScreen extends ConsumerWidget {
  const ProfileWorkDetailScreen({super.key, required this.work});
  final ProfileWork work;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Production Record',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreMenu(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
              child: _ImageCard(work: work),
            ),
          ),
          _SaveButton(
            onTap: () => _save(context),
            bottomPadding: bottomPadding,
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to gallery')),
    );
  }

  void _showMoreMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _MoreMenu(
        onReport: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report submitted')),
          );
        },
        onDelete: () {
          Navigator.pop(context);
          _confirmDelete(context, ref);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this creation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(babyDataRepositoryProvider).removeProfileWork(work.id);
              if (context.mounted) context.pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Image card ─────────────────────────────────────────────────────────────────

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.work});
  final ProfileWork work;

  @override
  Widget build(BuildContext context) {
    final url = work.coverUrl.isNotEmpty ? work.coverUrl : work.mediaUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppMetrics.radiusL),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _Placeholder(),
              )
            : _Placeholder(),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(Icons.image_outlined, size: 64, color: AppColors.textHint),
      ),
    );
  }
}

// ── Save button ────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap, required this.bottomPadding});
  final VoidCallback onTap;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24 + bottomPadding,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
            borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
          ),
          child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
              ),
            ),
            child: const Text(
              'Save to Phone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── More menu sheet ────────────────────────────────────────────────────────────

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.onReport, required this.onDelete});
  final VoidCallback onReport;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Report'),
            onTap: onReport,
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppColors.error),
            title: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
