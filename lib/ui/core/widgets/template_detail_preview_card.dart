import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Full 3:4 preview card for photo/dance detail ViewPager.
///
/// When [videoController] is provided the foreground renders the live video
/// stream (hardware-decoded via media_kit); the blurred background still uses
/// a static cover image so the card looks filled even while the video loads.
/// Without [videoController] the card falls back to its original image-only
/// behaviour, keeping PhotoDetailScreen unaffected.
class TemplateDetailPreviewCard extends StatelessWidget {
  const TemplateDetailPreviewCard({
    super.key,
    required this.item,
    this.borderRadius = 20.0,
    this.videoController,
  });

  final TemplateItem item;
  final double borderRadius;
  final VideoController? videoController;

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
              // 1. Soft blurred background - fills any letterbox area gracefully
              if (mediaUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: mediaUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => fallbackUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: fallbackUrl,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink(),
                ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  color: Colors.black.withAlpha(35),
                ),
              ),

              // 2. Foreground: live video when controller is provided, image otherwise.
              if (videoController != null)
                Video(
                  controller: videoController!,
                  fit: BoxFit.contain,
                  controls: (VideoState state) => const SizedBox.shrink(),
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

              // 3. Dance-only: small cover thumbnail at bottom-left (example input reference)
              if (videoController != null && item.originCoverUrl.isNotEmpty)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(60),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: item.originCoverUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 144,
                        memCacheHeight: 144,
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.child_care, color: AppColors.textHint, size: 28),
                        ),
                      ),
                    ),
                  ),
                ),
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
