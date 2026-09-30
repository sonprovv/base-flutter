import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/template_detail_preview_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class DanceDetailScreen extends ConsumerStatefulWidget {
  const DanceDetailScreen({super.key, required this.template});

  final TemplateItem template;

  @override
  ConsumerState<DanceDetailScreen> createState() => _DanceDetailScreenState();
}

class _DanceDetailScreenState extends ConsumerState<DanceDetailScreen> {
  late PageController _pageController;
  VideoPlayerController? _videoController;

  List<TemplateItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _items = [widget.template];
    _pageController = PageController(viewportFraction: 0.82);
    unawaited(_loadTemplates());
  }

  Future<void> _loadTemplates() async {
    try {
      final repo = ref.read(babyDataRepositoryProvider);
      final dance = await repo.getDanceTemplates();
      final recommends = await repo.getHomeRecommends();

      // Search across ALL sources: match by category name first, then by template ID.
      final all = [...recommends, ...dance];
      final targetName = widget.template.category;
      CategoryItem? targetCat;
      if (targetName.isNotEmpty) {
        for (final cat in all) {
          if (cat.name == targetName) { targetCat = cat; break; }
        }
      }
      targetCat ??= all.firstWhere(
        (cat) => cat.templates.any((t) => t.id == widget.template.id),
        orElse: () => dance.isNotEmpty ? dance.first : all.first,
      );

      final list = targetCat.templates;
      if (list.isNotEmpty && mounted) {
        final initialIndex = list.indexWhere((t) => t.id == widget.template.id);
        final safeIndex = initialIndex >= 0 ? initialIndex : 0;
        _pageController.dispose();
        _pageController = PageController(viewportFraction: 0.82, initialPage: safeIndex);
        setState(() {
          _items = list;
          _currentIndex = safeIndex;
          _isLoading = false;
        });
        unawaited(_playVideo(list[safeIndex].previewMp4Url));
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _playVideo(String url) async {
    final old = _videoController;
    _videoController = null;

    await old?.dispose();

    if (url.isEmpty || !mounted) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      await controller.setLooping(true);
      await controller.play();
      setState(() => _videoController = controller);
    } catch (_) {
      await controller.dispose();
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    unawaited(_playVideo(_items[index].previewMp4Url));
  }

  @override
  void dispose() {
    unawaited(_videoController?.dispose());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _items.isNotEmpty ? _items[_currentIndex] : widget.template;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back + Points Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/icon_back.png',
                      width: 26,
                      height: 26,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.arrow_back, color: AppColors.onBackground, size: 26),
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(AppRoute.paywall),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Swipeable 3:4 Preview Carousel
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _items.length,
                      clipBehavior: Clip.none,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final isCenter = index == _currentIndex;
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double pageOffset = 0.0;
                            if (_pageController.position.haveDimensions) {
                              final page = _pageController.page ?? _currentIndex.toDouble();
                              pageOffset = (index - page).abs().clamp(0.0, 1.0);
                            } else {
                              pageOffset = (index - _currentIndex).toDouble().abs().clamp(0.0, 1.0);
                            }
                            final double scale = 1.0 - (pageOffset * 0.14);
                            final double opacity = 1.0 - (pageOffset * 0.25);
                            return Transform.scale(
                              scale: scale,
                              alignment: Alignment.center,
                              child: Opacity(opacity: opacity, child: child),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: TemplateDetailPreviewCard(
                              item: item,
                              videoController: isCenter ? _videoController : null,
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Bottom CTA Button
            Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF5A48E0)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: () {
                    unawaited(context.push(AppRoute.templateGenerate, extra: currentItem));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        context.l10n.generateBabyPhoto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${currentItem.points > 0 ? currentItem.points : 30}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
