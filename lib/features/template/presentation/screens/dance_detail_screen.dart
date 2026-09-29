import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/template_detail_preview_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class DanceDetailScreen extends ConsumerStatefulWidget {
  const DanceDetailScreen({super.key, required this.template});

  final TemplateItem template;

  @override
  ConsumerState<DanceDetailScreen> createState() => _DanceDetailScreenState();
}

class _DanceDetailScreenState extends ConsumerState<DanceDetailScreen> {
  late PageController _pageController;
  late Player _player;
  late VideoController _videoController;

  List<TemplateItem> _items = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _items = [widget.template];
    _pageController = PageController(viewportFraction: 0.82);
    _player = Player();
    _videoController = VideoController(_player);

    // Start playing the initial template immediately if it has a video.
    final initialUrl = widget.template.previewMp4Url;
    if (initialUrl.isNotEmpty) {
      unawaited(_player.open(Media(initialUrl)));
    }

    unawaited(_loadTemplates());
  }

  Future<void> _loadTemplates() async {
    try {
      final repo = ref.read(babyDataRepositoryProvider);
      final categories = await repo.getDanceTemplates();
      final targetCat = categories.firstWhere(
        (cat) => cat.templates.any((t) => t.id == widget.template.id),
        orElse: () => categories.isNotEmpty ? categories.first : categories.first,
      );

      final list = targetCat.templates;
      if (list.isNotEmpty && mounted) {
        final initialIndex = list.indexWhere((t) => t.id == widget.template.id);
        final safeIndex = initialIndex >= 0 ? initialIndex : 0;
        setState(() {
          _items = list;
          _currentIndex = safeIndex;
          _isLoading = false;
        });
        // Re-open with the confirmed URL from the full list (same item, no flicker).
        final url = list[safeIndex].previewMp4Url;
        if (url.isNotEmpty) {
          unawaited(_player.open(Media(url)));
        }
        if (safeIndex > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients && mounted) {
              _pageController.jumpToPage(safeIndex);
            }
          });
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    final url = _items[index].previewMp4Url;
    if (url.isNotEmpty) {
      unawaited(_player.open(Media(url)));
    } else {
      unawaited(_player.stop());
    }
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
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
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.onBackground,
                      size: 26,
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
                        // Only the center card gets the live VideoController;
                        // side peeking cards show a static cover image.
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
                              videoController: isCenter && item.previewMp4Url.isNotEmpty
                                  ? _videoController
                                  : null,
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
                      const Text(
                        'Generate Baby Photo',
                        style: TextStyle(
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
