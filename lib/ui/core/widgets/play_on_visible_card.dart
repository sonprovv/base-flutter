import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/network_image_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Shows [staticUrl] (static cover) when off-screen; switches to [gifUrl]
/// (animated GIF or video thumbnail) only when ≥50% of the card is visible.
/// Falls back to behaving like [NetworkImageCard] when gifUrl == staticUrl.
class PlayOnVisibleCard extends StatefulWidget {
  const PlayOnVisibleCard({
    super.key,
    required this.id,
    required this.staticUrl,
    required this.gifUrl,
    this.fallbackUrl = '',
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.overlay,
    this.onTap,
  });

  final String id;
  final String staticUrl;
  final String gifUrl;
  final String fallbackUrl;
  final double width;
  final double height;
  final double borderRadius;
  final Widget? overlay;
  final VoidCallback? onTap;

  @override
  State<PlayOnVisibleCard> createState() => _PlayOnVisibleCardState();
}

class _PlayOnVisibleCardState extends State<PlayOnVisibleCard> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('pov_${widget.id}'),
      onVisibilityChanged: (info) {
        final v = info.visibleFraction >= 0.5;
        if (v != _visible && mounted) setState(() => _visible = v);
      },
      child: NetworkImageCard(
        url: _visible ? widget.gifUrl : widget.staticUrl,
        fallbackUrl: widget.fallbackUrl.isNotEmpty
            ? widget.fallbackUrl
            : widget.staticUrl,
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
        overlay: widget.overlay,
        onTap: widget.onTap,
      ),
    );
  }
}
