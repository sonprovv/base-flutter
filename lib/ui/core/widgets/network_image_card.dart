import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';

class NetworkImageCard extends StatelessWidget {
  const NetworkImageCard({
    super.key,
    required this.url,
    this.fallbackUrl = '',
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.overlay,
    this.onTap,
  });

  final String url;
  final String fallbackUrl;
  final double width;
  final double height;
  final double borderRadius;
  final Widget? overlay;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              url.isEmpty
                  ? _placeholder()
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      memCacheWidth: width.isFinite && width > 0 ? (width * 2).ceil() : null,
                      memCacheHeight: height.isFinite && height > 0 ? (height * 2).ceil() : null,
                      fadeInDuration: const Duration(milliseconds: 180),
                      fadeOutDuration: const Duration(milliseconds: 100),
                      placeholder: (context, imageUrl) => _placeholder(),
                      errorWidget: (context, imageUrl, error) =>
                          fallbackUrl.isNotEmpty && fallbackUrl != url
                              ? CachedNetworkImage(
                                  imageUrl: fallbackUrl,
                                  fit: BoxFit.cover,
                                  memCacheWidth: width.isFinite && width > 0 ? (width * 2).ceil() : null,
                                  memCacheHeight: height.isFinite && height > 0 ? (height * 2).ceil() : null,
                                  fadeInDuration: const Duration(milliseconds: 180),
                                  placeholder: (c, u) => _placeholder(),
                                  errorWidget: (c, u, e) => _errorWidget(),
                                )
                              : _errorWidget(),
                    ),
              ?overlay,
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surfaceVariant,
      child: Image.asset(
        'assets/images/ic_placeholder.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.image_outlined, color: AppColors.textHint, size: 28),
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      color: AppColors.surfaceVariant,
      child: Image.asset(
        'assets/images/ic_no_network.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.signal_wifi_off_outlined, color: AppColors.textHint, size: 28),
        ),
      ),
    );
  }
}
