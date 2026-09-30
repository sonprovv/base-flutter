import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:video_player/video_player.dart';

/// Full 3:4 preview card for photo/dance detail ViewPager.
/// Pass [videoController] (already initialized) to show live video on the
/// center card; side cards and photo cards fall back to animated WebP/GIF.
class TemplateDetailPreviewCard extends StatelessWidget {
  const TemplateDetailPreviewCard({
    super.key,
    required this.item,
    this.borderRadius = 20.0,
    this.videoController,
  });

  final TemplateItem item;
  final double borderRadius;
  final VideoPlayerController? videoController;

  @override
  Widget build(BuildContext context) {
    final mediaUrl = item.displayMediaUrl;
    final fallbackUrl = item.coverUrl;

    return Center(
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E24),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Blurred background — fills letterbox gracefully
              if (mediaUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: mediaUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => fallbackUrl.isNotEmpty
                      ? CachedNetworkImage(imageUrl: fallbackUrl, fit: BoxFit.cover)
                      : const SizedBox.shrink(),
                ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(color: Colors.black.withAlpha(35)),
              ),

              // Foreground: live video on center card, image on side cards
              if (videoController != null && videoController!.value.isInitialized)
                Center(
                  child: AspectRatio(
                    aspectRatio: videoController!.value.aspectRatio,
                    child: VideoPlayer(videoController!),
                  ),
                )
              else if (mediaUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: mediaUrl,
                  fit: BoxFit.contain,
                  fadeInDuration: const Duration(milliseconds: 200),
                  placeholder: (context, _) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.primary,
                    ),
                  ),
                  errorWidget: (context, _, _) => fallbackUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: fallbackUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, _) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.primary,
                            ),
                          ),
                          errorWidget: (_, _, _) => _errorPlaceholder(),
                        )
                      : _errorPlaceholder(),
                )
              else
                _errorPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Image.asset(
          'assets/images/ic_placeholder.png',
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
