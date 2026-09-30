import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/feedback_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class RateAppDialog extends StatefulWidget {
  const RateAppDialog({super.key, required this.playStoreUrl});

  final String playStoreUrl;

  static Future<void> show(BuildContext context, {required String playStoreUrl}) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => RateAppDialog(playStoreUrl: playStoreUrl),
    );
  }

  @override
  State<RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<RateAppDialog>
    with SingleTickerProviderStateMixin {
  int _star = 0;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  _RatingContent get _content => _RatingContent.forStar(_star);

  Future<void> _onActionTap() async {
    Navigator.of(context).pop();
    if (_star >= 1 && _star <= 3) {
      if (mounted) {
        await FeedbackDialog.show(context);
      }
    } else {
      final uri = Uri.parse(widget.playStoreUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _content;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                title: content.title,
                onClose: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 16),
              _PulsingStarIllustration(animation: _pulseAnim),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    content.subtitle,
                    key: ValueKey(_star),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                itemCount: 5,
                itemSize: 38,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                glow: false,
                itemBuilder: (_, _) => const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFC107),
                ),
                unratedColor: const Color(0xFFCCCCCC),
                onRatingUpdate: (v) => setState(() => _star = v.round()),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMetrics.screenPaddingHorizontal,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: ElevatedButton(
                      key: ValueKey(content.buttonText),
                      onPressed: _star > 0 ? _onActionTap : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        disabledBackgroundColor: AppColors.outline,
                        disabledForegroundColor: AppColors.textHint,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        content.buttonText,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingContent {
  const _RatingContent({
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  final String title;
  final String subtitle;
  final String buttonText;

  static _RatingContent forStar(int star) => switch (star) {
        1 => const _RatingContent(
            title: "Oh no! We're sorry to hear that.",
            subtitle:
                'Your feedback is crucial for us to improve. Could you please tell us what went wrong?',
            buttonText: 'Give Private Feedback',
          ),
        2 => const _RatingContent(
            title: 'Heartbreaking!',
            subtitle: 'What could we do to earn a 5-star rating from you?',
            buttonText: 'Give Private Feedback',
          ),
        3 => const _RatingContent(
            title: 'Thanks for the feedback!',
            subtitle: "We'd love to know how we can make your experience better.",
            buttonText: 'Suggest an Improvement',
          ),
        4 => const _RatingContent(
            title: 'Thanks for your support!',
            subtitle: "We're glad you're enjoying the app! Public reviews help us grow.",
            buttonText: 'Rate on Play Store',
          ),
        5 => const _RatingContent(
            title: 'Awesome! You made our day!',
            subtitle: 'Your satisfaction makes all of our hard work worthwhile',
            buttonText: 'Rate on Play Store',
          ),
        _ => const _RatingContent(
            title: 'Enjoying our app?',
            subtitle: 'Enjoying our app?',
            buttonText: 'Rate us now',
          ),
      };
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: AppColors.primary,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  title,
                  key: ValueKey(title),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 6,
            child: IconButton(
              onPressed: onClose,
              icon: Image.asset(
                'assets/images/ic_white_cha.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(Icons.close, color: AppColors.onPrimary, size: 20),
              ),
              padding: const EdgeInsets.all(9),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingStarIllustration extends StatelessWidget {
  const _PulsingStarIllustration({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: Container(
        width: 90,
        height: 90,
        decoration: const BoxDecoration(
          color: AppColors.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/images/ic_start_mid.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(Icons.star_rounded, size: 56, color: Color(0xFFFFC107)),
        ),
      ),
    );
  }
}
