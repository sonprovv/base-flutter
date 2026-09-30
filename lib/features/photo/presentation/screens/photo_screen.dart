import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/features/photo/presentation/view_models/photo_view_model.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/network_image_card.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/section_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PhotoScreen extends ConsumerWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(photoViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
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
                    context.l10n.babyTemplateTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
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
                          context.l10n.failedToLoadPhotos(e.toString()),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => ref.refresh(photoViewModelProvider),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (categories) => SingleChildScrollView(
                  child: Column(
                    children: [
                      ...categories.map((cat) => _PhotoCategorySection(category: cat)),
                      const SizedBox(height: AppMetrics.spaceXl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoCategorySection extends StatelessWidget {

  const _PhotoCategorySection({required this.category});
  final CategoryItem category;

  @override
  Widget build(BuildContext context) {
    if (category.isGrid) {
      return _GridSection(category: category);
    }
    return _HorizontalSection(category: category);
  }
}

class _HorizontalSection extends StatelessWidget {

  const _HorizontalSection({required this.category});
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
              return Padding(
                padding: const EdgeInsets.only(right: AppMetrics.spaceXs),
                child: NetworkImageCard(
                  url: item.displayMediaUrl,
                  fallbackUrl: item.coverUrl,
                  width: AppMetrics.homeSectionCardWidth,
                  height: AppMetrics.homeSectionCardHeight,
                  borderRadius: AppMetrics.radiusL,
                  overlay: _nameOverlay(item.name),
                  onTap: () => context.push(AppRoute.photoDetail, extra: item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GridSection extends StatelessWidget {

  const _GridSection({required this.category});
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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppMetrics.screenPaddingHorizontal,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppMetrics.spaceXs,
              mainAxisSpacing: AppMetrics.spaceXs,
              childAspectRatio: 0.75,
            ),
            itemCount: category.templates.length > 6 ? 6 : category.templates.length,
            itemBuilder: (context, index) {
              final item = category.templates[index];
              return NetworkImageCard(
                url: item.displayMediaUrl,
                fallbackUrl: item.coverUrl,
                width: double.infinity,
                height: double.infinity,
                borderRadius: AppMetrics.radiusM,
                overlay: _nameOverlay(item.name),
                onTap: () => context.push(AppRoute.photoDetail, extra: item),
              );
            },
          ),
        ),
      ],
    );
  }
}

Positioned _nameOverlay(String name) {
  return Positioned(
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
        name,
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
}
