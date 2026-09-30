import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Looping muted video card that only initializes and plays when ≥50%
/// visible in the viewport. Pauses automatically when scrolled out of view.
/// Shows [fallbackImageUrl] while hidden or while the video loads.
class VideoThumbnailCard extends StatefulWidget {
  const VideoThumbnailCard({
    super.key,
    required this.id,
    required this.mp4Url,
    required this.fallbackImageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
    this.overlay,
    this.onTap,
  });

  final String id;
  final String mp4Url;
  final String fallbackImageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final Widget? overlay;
  final VoidCallback? onTap;

  @override
  State<VideoThumbnailCard> createState() => _VideoThumbnailCardState();
}

class _VideoThumbnailCardState extends State<VideoThumbnailCard>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(_controller?.pause());
      case AppLifecycleState.resumed:
        if (_visible) unawaited(_controller?.play());
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final visible = info.visibleFraction >= 0.5;
    if (visible == _visible) return;
    _visible = visible;
    if (visible) {
      if (!_initialized) {
        unawaited(_initVideo());
      } else {
        unawaited(_controller?.play());
      }
    } else {
      unawaited(_controller?.pause());
    }
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.mp4Url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    await controller.setLooping(true);
    await controller.setVolume(0);
    await controller.initialize();
    if (!mounted) {
      unawaited(controller.dispose());
      return;
    }
    _controller = controller;
    if (mounted) setState(() => _initialized = true);
    // Only play if still visible after async init
    if (_visible) unawaited(controller.play());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('vtc_${widget.id}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_initialized && _controller != null)
                  _VideoFill(controller: _controller!)
                else
                  _Fallback(url: widget.fallbackImageUrl),
                if (widget.overlay != null) widget.overlay!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoFill extends StatelessWidget {
  const _VideoFill({required this.controller});
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final size = controller.value.size;
    if (size.isEmpty) return const SizedBox.shrink();
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return Container(color: AppColors.surfaceVariant);
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(color: AppColors.surfaceVariant),
      errorWidget: (_, _, _) => Container(color: AppColors.surfaceVariant),
    );
  }
}
