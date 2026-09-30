import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/feature_item.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/play_on_visible_card.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/section_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

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
                  Image.asset(
                    'assets/images/ic_baby_genie_title.png',
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Text(
                      context.l10n.appName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
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
                          '${context.l10n.homeLoadError}: $e',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => ref.refresh(homeViewModelProvider),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (data) => _HomeContent(
                  features: data.features,
                  categories: data.categories,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {

  const _HomeContent({required this.features, required this.categories});
  final List<FeatureItem> features;
  final List<CategoryItem> categories;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Feature carousel
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppMetrics.spaceXs),
              SizedBox(
                height: AppMetrics.homeFeatureCardHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppMetrics.screenPaddingHorizontal,
                  ),
                  itemCount: features.length,
                  itemBuilder: (context, index) =>
                      _FeatureCard(feature: features[index]),
                ),
              ),
              const SizedBox(height: AppMetrics.spaceM),
            ],
          ),
        ),
        // Each category as its own sliver — only rendered when scrolled into view
        for (final cat in categories) ...[
          SliverToBoxAdapter(child: _CategorySection(category: cat)),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: AppMetrics.spaceXl)),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});
  final FeatureItem feature;

  String get _route => switch (feature.id) {
        'future_baby' => AppRoute.futureBaby,
        'future_family' => AppRoute.futureFamily,
        'family_similarity' => AppRoute.familySimilarity,
        'ultrasound' => AppRoute.ultrasound,
        _ => AppRoute.futureBaby,
      };

  String get _asset => switch (feature.id) {
        'future_baby' => 'assets/images/ic_main_future_baby.png',
        'future_family' => 'assets/images/ic_main_future_family.png',
        'family_similarity' => 'assets/images/ic_main_family_similarity.png',
        'ultrasound' => 'assets/images/ic_main_ultrasound_viewer.png',
        _ => '',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(_route),
      child: Container(
        width: AppMetrics.homeFeatureCardWidth,
        height: AppMetrics.homeFeatureCardHeight,
        margin: const EdgeInsets.only(right: AppMetrics.spaceS),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppMetrics.radiusM),
          color: AppColors.surfaceVariant,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_asset.isNotEmpty)
              Image.asset(
                _asset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.surfaceVariant),
              )
            else
              Container(color: AppColors.surfaceVariant),
            // gradient + name overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 24, 10, 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(AppMetrics.radiusM),
                    bottomRight: Radius.circular(AppMetrics.radiusM),
                  ),
                ),
                child: Text(
                  feature.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {

  const _CategorySection({required this.category});
  final CategoryItem category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppMetrics.spaceXs),
        SectionHeader(
          title: category.name,
          onSeeAll: () => context.push(
            AppRoute.templateList,
            extra: {'category': category.name},
          ),
        ),
        const SizedBox(height: AppMetrics.spaceXs),
        if (category.isGrid)
          SizedBox(
            height: 312,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppMetrics.screenPaddingHorizontal,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppMetrics.spaceXs,
                crossAxisSpacing: AppMetrics.spaceXs,
                childAspectRatio: 1.05,
              ),
              itemCount: category.templates.length,
              itemBuilder: (context, index) => _TemplateCard(
                template: category.templates[index],
                width: 140,
                height: 148,
              ),
            ),
          )
        else
          SizedBox(
            height: AppMetrics.homeSectionCardHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppMetrics.screenPaddingHorizontal,
              ),
              itemCount: category.templates.length,
              itemBuilder: (context, index) => _TemplateCard(
                template: category.templates[index],
              ),
            ),
          ),
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {

  const _TemplateCard({
    required this.template,
    this.width = AppMetrics.homeSectionCardWidth,
    this.height = AppMetrics.homeSectionCardHeight,
  });
  final TemplateItem template;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppMetrics.spaceXs),
      child: PlayOnVisibleCard(
        id: template.id.isNotEmpty ? template.id : template.name,
        staticUrl: template.coverUrl,
        gifUrl: template.displayMediaUrl,
        fallbackUrl: template.coverUrl,
        width: width,
        height: height,
        borderRadius: AppMetrics.radiusL,
        overlay: Positioned(
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
              template.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        onTap: () {
          if (template.isVideo) {
            unawaited(context.push(AppRoute.danceDetail, extra: template));
          } else {
            unawaited(context.push(AppRoute.photoDetail, extra: template));
          }
        },
      ),
    );
  }
}
