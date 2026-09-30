import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (data) => _ProfileContent(state: data),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {

  const _ProfileContent({required this.state});
  final ProfileState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(profileViewModelProvider.notifier);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppMetrics.screenPaddingHorizontal,
                  AppMetrics.spaceM,
                  AppMetrics.screenPaddingHorizontal,
                  AppMetrics.spaceXs,
                ),
                child: Row(
                  children: [
                    Text(
                      context.l10n.profileTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.push(AppRoute.settings),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/ic_profile_setting.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.settings_outlined,
                            color: AppColors.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // User info row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMetrics.screenPaddingHorizontal,
                  vertical: AppMetrics.spaceS,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppMetrics.profileAvatarSize / 2,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/ic_profile_mine_setting.png',
                          width: AppMetrics.profileAvatarSize,
                          height: AppMetrics.profileAvatarSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppMetrics.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.profileUser,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.profileCreations(state.works.length),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // VIP Pro Banner
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppMetrics.screenPaddingHorizontal,
                  AppMetrics.spaceXs,
                  AppMetrics.screenPaddingHorizontal,
                  AppMetrics.spaceS,
                ),
                child: GestureDetector(
                  onTap: () => context.push(AppRoute.paywall),
                  child: Container(
                    height: AppMetrics.profileProBannerHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppMetrics.radiusM),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/ic_profile_mine.png'),
                        fit: BoxFit.fill,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF39C12).withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/ic_profile_king.png',
                          width: 34,
                          height: 34,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'BabyGenie VIP',
                                      style: TextStyle(
                                        color: Color(0xFF5A3900),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Image(
                                    image: AssetImage('assets/images/ic_profile_start.png'),
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Unlock all features & HD export',
                                style: TextStyle(
                                  color: Color(0xFF7A5200),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5A3900), Color(0xFF382300)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Get VIP',
                            style: TextStyle(
                              color: Color(0xFFFFE79A),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMetrics.screenPaddingHorizontal,
                  vertical: AppMetrics.spaceXs,
                ),
                child: Row(
                  children: WorkFilter.values.map((f) {
                    final isSelected = state.filter == f;
                    final label = switch (f) {
                      WorkFilter.all => context.l10n.filterAll,
                      WorkFilter.video => context.l10n.filterVideo,
                      WorkFilter.photo => context.l10n.filterPhoto,
                    };
                    return Padding(
                      padding: const EdgeInsets.only(right: AppMetrics.spaceXs),
                      child: GestureDetector(
                        onTap: () => vm.setFilter(f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppMetrics.spaceM,
                            vertical: AppMetrics.spaceXs,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius:
                                BorderRadius.circular(AppMetrics.radiusPill),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppMetrics.spaceXs),
            ],
          ),
        ),
        if (state.filtered.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/icon_mapstotage_frg_nodata.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.onSurfaceVariant,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: AppMetrics.spaceS),
                  Text(
                    context.l10n.noCreationsYet,
                    style: const TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppMetrics.screenPaddingHorizontal,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final work = state.filtered[index];
                  return _WorkItem(
                    work: work,
                    onDelete: () => vm.removeWork(work.id),
                  );
                },
                childCount: state.filtered.length,
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppMetrics.spaceXl)),
      ],
    );
  }
}

class _WorkItem extends StatelessWidget {
  const _WorkItem({required this.work, required this.onDelete});
  final ProfileWork work;
  final VoidCallback onDelete;

  void _confirmDelete(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Delete',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text('Delete this work? It cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF888888))),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onDelete();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: work.isCompleted
          ? () => context.push(AppRoute.profileWorkDetail, extra: work)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left cover 92×122
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: 92,
                height: 122,
                child: _CoverImage(work: work),
              ),
            ),
            // Middle info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      work.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF181818),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _statusMessage(work, context.l10n),
                      style: TextStyle(
                        fontSize: 12,
                        color: work.isFailed
                            ? AppColors.error
                            : work.isProcessing
                                ? const Color(0xFF888888)
                                : const Color(0xFFE8A12B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatTime(work.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Delete icon
            IconButton(
              onPressed: () => _confirmDelete(context),
              icon: Image.asset(
                'assets/images/ic_profile_delete.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusMessage(ProfileWork w, AppL10n l10n) {
    if (w.isCompleted) return l10n.workFilesAvailable;
    if (w.isFailed) return l10n.workGenerationFailed;
    return 'Expected to wait for 30 minutes, please be patient';
  }

  String _formatTime(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.work});
  final ProfileWork work;

  @override
  Widget build(BuildContext context) {
    final url = work.coverUrl.isNotEmpty ? work.coverUrl : work.previewWebpUrl;

    if (work.isProcessing) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _renderImage(url),
          Container(color: Colors.black45),
          const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.5,
              ),
            ),
          ),
        ],
      );
    }

    if (work.isFailed) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _placeholder(),
          Center(
            child: Image.asset(
              'assets/images/ic_profile_fail.png',
              width: 34,
              height: 34,
              errorBuilder: (_, _, _) => const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 32,
              ),
            ),
          ),
        ],
      );
    }

    // completed
    return Stack(
      fit: StackFit.expand,
      children: [
        _renderImage(url),
        if (work.isVideo)
          Center(
            child: Image.asset(
              'assets/images/icon_showvideo_play.png',
              width: 28,
              height: 28,
              errorBuilder: (_, _, _) => const Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
      ],
    );
  }

  Widget _renderImage(String path) {
    if (path.isEmpty) return _placeholder();
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.surfaceVariant,
        child: const Icon(
          Icons.image_outlined,
          size: 32,
          color: AppColors.textHint,
        ),
      );
}
