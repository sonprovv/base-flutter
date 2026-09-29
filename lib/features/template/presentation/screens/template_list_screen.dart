import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/play_on_visible_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _templateListProvider =
    FutureProvider.family<List<TemplateItem>, String>((ref, category) async {
  final repo = ref.read(babyDataRepositoryProvider);
  final allDance = await repo.getDanceTemplates();
  final allPhoto = await repo.getPhotoTemplates();
  final all = [...allDance, ...allPhoto];
  for (final cat in all) {
    if (cat.name == category) return cat.templates;
  }
  return [];
});

class TemplateListScreen extends ConsumerWidget {

  const TemplateListScreen({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_templateListProvider(category));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.onBackground),
        title: Text(
          category,
          style: const TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) => items.isEmpty
            ? const Center(
                child: Text(
                  'No templates found',
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppMetrics.spaceS,
                  mainAxisSpacing: AppMetrics.spaceS,
                  childAspectRatio: 0.72,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return PlayOnVisibleCard(
                    id: item.id.isNotEmpty ? item.id : '$index',
                    staticUrl: item.coverUrl,
                    gifUrl: item.displayMediaUrl,
                    fallbackUrl: item.coverUrl,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: AppMetrics.radiusM,
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
                            bottomLeft:
                                Radius.circular(AppMetrics.radiusM),
                            bottomRight:
                                Radius.circular(AppMetrics.radiusM),
                          ),
                        ),
                        child: Text(
                          item.name,
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
                      if (item.isVideo) {
                        unawaited(context.push(AppRoute.danceDetail, extra: item));
                      } else {
                        unawaited(context.push(AppRoute.photoDetail, extra: item));
                      }
                    },
                  );
                },

              ),
      ),
    );
  }
}
