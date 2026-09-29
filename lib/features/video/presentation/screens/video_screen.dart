import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/features/video/presentation/view_models/video_view_model.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/play_on_visible_card.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/section_header.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/video_thumbnail_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VideoScreen extends ConsumerWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(videoViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                  const Text(
                    'BabyDance',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(AppRoute.paywall),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppMetrics.spaceS,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.gradientStart, AppColors.gradientEnd],
                        ),
                        borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: AppColors.white, size: 14),
                          SizedBox(width: 4),
                          Text('PRO',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load videos: $e',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => ref.refresh(videoViewModelProvider),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (categories) => CustomScrollView(
                  slivers: [
                    for (final cat in categories)
                      SliverToBoxAdapter(child: _DanceCategorySection(category: cat)),
                    const SliverToBoxAdapter(child: SizedBox(height: AppMetrics.spaceXl)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DanceCategorySection extends StatelessWidget {

  const _DanceCategorySection({required this.category});
  final CategoryItem category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppMetrics.spaceS),
        SectionHeader(
          title: category.name,
          onSeeAll: () => context.push(
            AppRoute.templateList,
            extra: {'category': category.name},
          ),
        ),
        const SizedBox(height: AppMetrics.spaceXs),
        SizedBox(
          height: AppMetrics.homeSectionCardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppMetrics.screenPaddingHorizontal,
            ),
            itemCount: category.templates.length,
            itemBuilder: (context, index) {
              final item = category.templates[index];
              final nameOverlay = Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppMetrics.spaceXs),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppMetrics.radiusL),
                      bottomRight: Radius.circular(AppMetrics.radiusL),
                    ),
                  ),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
              final cardId = item.id.isNotEmpty ? item.id : '$index';
              return Padding(
                padding: const EdgeInsets.only(right: AppMetrics.spaceXs),
                child: item.previewMp4Url.isNotEmpty
                    ? VideoThumbnailCard(
                        id: cardId,
                        mp4Url: item.previewMp4Url,
                        fallbackImageUrl: item.coverUrl,
                        width: AppMetrics.homeSectionCardWidth,
                        height: AppMetrics.homeSectionCardHeight,
                        borderRadius: AppMetrics.radiusL,
                        overlay: nameOverlay,
                        onTap: () => context.push(AppRoute.danceDetail, extra: item),
                      )
                    : PlayOnVisibleCard(
                        id: cardId,
                        staticUrl: item.coverUrl,
                        gifUrl: item.displayMediaUrl,
                        fallbackUrl: item.coverUrl,
                        width: AppMetrics.homeSectionCardWidth,
                        height: AppMetrics.homeSectionCardHeight,
                        borderRadius: AppMetrics.radiusL,
                        overlay: nameOverlay,
                        onTap: () => context.push(AppRoute.danceDetail, extra: item),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
