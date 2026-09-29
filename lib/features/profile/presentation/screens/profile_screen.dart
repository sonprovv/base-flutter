import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/network_image_card.dart';
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
                    const Text(
                      'Profile',
                      style: TextStyle(
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
                      child: const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppMetrics.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BabyGenie User',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.works.length} creations',
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
              // PRO banner
              GestureDetector(
                onTap: () => context.push(AppRoute.paywall),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppMetrics.screenPaddingHorizontal,
                    vertical: AppMetrics.spaceXs,
                  ),
                  padding: const EdgeInsets.all(AppMetrics.spaceM),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(AppMetrics.radiusM),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.star, color: AppColors.white, size: 20),
                      SizedBox(width: AppMetrics.spaceS),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upgrade to PRO',
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Unlock unlimited generations',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios,
                          color: AppColors.white, size: 14),
                    ],
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
                      WorkFilter.all => 'All',
                      WorkFilter.video => 'Video',
                      WorkFilter.photo => 'Photo',
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
          const SliverFillRemaining(
            child: Center(
              child: Text(
                'No creations yet',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppMetrics.screenPaddingHorizontal,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppMetrics.spaceXs,
                mainAxisSpacing: AppMetrics.spaceXs,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final work = state.filtered[index];
                  return _WorkCard(work: work);
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

class _WorkCard extends StatelessWidget {

  const _WorkCard({required this.work});
  final ProfileWork work;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NetworkImageCard(
          url: work.coverUrl.isNotEmpty ? work.coverUrl : work.previewWebpUrl,
          width: double.infinity,
          height: double.infinity,
          borderRadius: AppMetrics.radiusM,
          onTap: () {},
        ),
        if (work.isVideo)
          const Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.play_circle_fill,
                color: AppColors.white, size: 24),
          ),
        Positioned(
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
                bottomLeft: Radius.circular(AppMetrics.radiusM),
                bottomRight: Radius.circular(AppMetrics.radiusM),
              ),
            ),
            child: Text(
              work.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
