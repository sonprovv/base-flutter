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
                      child: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.onBackground,
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
                      backgroundColor: AppColors.primaryContainer,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/ic_profile_mine.png',
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            // Right info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      work.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _statusMessage(work, context.l10n),
                      style: TextStyle(
                        fontSize: 12,
                        color: work.isFailed
                            ? AppColors.error
                            : const Color(0xFFE8A12B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(work.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Delete icon
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColors.textSecondary,
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
    return l10n.workWaiting;
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
          if (url.isNotEmpty)
            Image.network(url, fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder())
          else
            _placeholder(),
          Container(color: Colors.black54),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
              strokeWidth: 2,
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
          const Center(
            child: Icon(Icons.error_outline, color: AppColors.error, size: 32),
          ),
        ],
      );
    }

    // completed
    if (url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        color: AppColors.surfaceVariant,
        child: const Icon(Icons.image_outlined,
            size: 32, color: AppColors.textHint),
      );
}
