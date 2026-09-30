import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadReminderScreen extends StatefulWidget {
  const PhotoUploadReminderScreen({super.key});

  @override
  State<PhotoUploadReminderScreen> createState() =>
      _PhotoUploadReminderScreenState();
}

class _PhotoUploadReminderScreenState extends State<PhotoUploadReminderScreen> {
  final _picker = ImagePicker();
  bool _picking = false;

  Future<void> _pick(ImageSource source) async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final file = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
      );
      if (file != null && mounted) {
        context.pop(file.path);
      }
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  static const _goodPhotos = [
    'assets/images/ic_correct1.png',
    'assets/images/ic_correct2.png',
    'assets/images/ic_correct3.png',
  ];

  static const _badPhotos = [
    'assets/images/ic_error1.png',
    'assets/images/ic_error2.png',
    'assets/images/ic_error3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          context.l10n.uploadPhoto,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppMetrics.screenPaddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppMetrics.spaceM),
                  _GuidanceBanner(isGood: true),
                  const SizedBox(height: AppMetrics.spaceS),
                  _PhotoExampleRow(paths: _goodPhotos),
                  const SizedBox(height: AppMetrics.spaceM),
                  _GuidanceBanner(isGood: false),
                  const SizedBox(height: AppMetrics.spaceS),
                  _PhotoExampleRow(paths: _badPhotos),
                  const SizedBox(height: AppMetrics.spaceL),
                  ..._kPolicies.map((p) => _PolicySectionWidget(policy: p)),
                  const SizedBox(height: AppMetrics.spaceXl),
                ],
              ),
            ),
          ),
          _BottomBar(
            enabled: !_picking,
            onTakeSelfie: () => _pick(ImageSource.camera),
            onSelectPhoto: () => _pick(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

// ── Guidance banner ──────────────────────────────────────────────────────────

class _GuidanceBanner extends StatelessWidget {
  const _GuidanceBanner({required this.isGood});

  final bool isGood;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.spaceM,
        vertical: AppMetrics.spaceS,
      ),
      decoration: BoxDecoration(
        color: isGood
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(AppMetrics.radiusL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isGood ? Icons.check_circle : Icons.cancel,
            color: isGood ? const Color(0xFF4CAF50) : AppColors.error,
            size: 28,
          ),
          const SizedBox(width: AppMetrics.spaceS),
          Expanded(
            child: Text(
              isGood
                  ? context.l10n.photoGuidanceGood
                  : context.l10n.photoGuidanceBad,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Photo example row ─────────────────────────────────────────────────────────

class _PhotoExampleRow extends StatelessWidget {
  const _PhotoExampleRow({required this.paths});

  final List<String> paths;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < paths.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppMetrics.radiusM),
              child: Image.asset(paths[i], width: double.infinity, fit: BoxFit.fitWidth),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Policy section ────────────────────────────────────────────────────────────

class _PolicySectionWidget extends StatelessWidget {
  const _PolicySectionWidget({required this.policy});

  final _Policy policy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(policy.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: AppMetrics.spaceXs),
              Expanded(
                child: Text(
                  policy.heading,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppMetrics.spaceXs),
          Text(
            policy.body,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppMetrics.spaceXxs),
          ...policy.bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '• $b',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onTakeSelfie,
    required this.onSelectPhoto,
    this.enabled = true,
  });

  final VoidCallback onTakeSelfie;
  final VoidCallback onSelectPhoto;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppMetrics.screenPaddingHorizontal,
              AppMetrics.spaceS,
              AppMetrics.screenPaddingHorizontal,
              AppMetrics.spaceS + bottomInset,
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: AppMetrics.buttonHeight,
                  child: OutlinedButton.icon(
                    key: const ValueKey('btn_photo_take_selfie'),
                    onPressed: enabled ? onTakeSelfie : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined, size: 20),
                    label: Text(
                      context.l10n.takeSelfie,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: AppMetrics.spaceS),
                SizedBox(
                  width: double.infinity,
                  height: AppMetrics.buttonHeight,
                  child: FilledButton.icon(
                    key: const ValueKey('btn_photo_select_photo'),
                    onPressed: enabled ? onSelectPhoto : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_outlined, size: 20),
                    label: Text(
                      context.l10n.selectPhoto,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Policy data ───────────────────────────────────────────────────────────────

class _Policy {
  const _Policy({
    required this.emoji,
    required this.heading,
    required this.body,
    required this.bullets,
  });

  final String emoji;
  final String heading;
  final String body;
  final List<String> bullets;
}

const _kPolicies = [
  _Policy(
    emoji: '🔞',
    heading: 'NSFW (graphic violence, pornography, nudity)',
    body:
        'Users are prohibited from using our image or video tools to create NSFW content, which includes but is not limited to:',
    bullets: [
      'promoting explicitly violent behavior',
      'sexually explicit or suggestive content, pornography, erotica',
      'images or videos that depict nudity',
    ],
  ),
  _Policy(
    emoji: '🔞',
    heading: 'Child safety',
    body:
        'Users are prohibited from using our image or video tools to create content, which includes but is not limited to:',
    bullets: [
      'AI-generated depictions of minors',
      'sexual or suggestive content involving minors',
      'any form of child exploitation or harm',
    ],
  ),
  _Policy(
    emoji: '⚠️',
    heading: 'Violent content',
    body:
        'Users are prohibited from using our image or video tools to create violent content, which includes but is not limited to:',
    bullets: [
      'promoting suicide',
      'encouraging self-harm or injuring others',
      'causing property damage',
    ],
  ),
  _Policy(
    emoji: '💊',
    heading: 'Illegal content',
    body:
        'Users are prohibited from using our image or video tools to create illegal content, which includes but is not limited to:',
    bullets: [
      'promoting illegal drugs or controlled substances',
      'facilitating illegal activities',
      'violating applicable laws and regulations',
    ],
  ),
  _Policy(
    emoji: '💣',
    heading: 'Harmful content',
    body:
        'Users are prohibited from using our image or video tools to create harmful content, which includes but is not limited to:',
    bullets: [
      'applying weapons and explosives',
      'distributing harmful instructions',
    ],
  ),
  _Policy(
    emoji: '😡',
    heading: 'Offensive content',
    body:
        'Users are prohibited from using our image or video tools to create offensive content, which includes but is not limited to:',
    bullets: [
      'intending to vilify, humiliate, or incite through hate speech, profanity, and slurs',
      'evaluating individuals based on race, gender, age, or sexual orientation',
      'supporting ideologies founded on violence, hatred, or intolerance',
    ],
  ),
  _Policy(
    emoji: '🎰',
    heading: 'Gambling content',
    body:
        'Users are prohibited from using our image or video tools to create gambling content, which includes but is not limited to:',
    bullets: [
      'promoting gambling and sports betting content',
    ],
  ),
  _Policy(
    emoji: '💻',
    heading: 'Fraudulent content',
    body:
        'Users are prohibited from using our image or video tools to create fraudulent content, which includes but is not limited to:',
    bullets: [
      'involving fraudulent or deceptive behavior',
      'promoting disinformation, misinformation, or false online engagement',
    ],
  ),
  _Policy(
    emoji: '🚫',
    heading: 'SPI (Sensitive Personally Identifiable Information)',
    body:
        'Users are prohibited from using our image or video tools to create fraudulent content, which includes but is not limited to:',
    bullets: [
      'involving fraudulent or deceptive behavior',
      'promoting disinformation, misinformation, or false online engagement',
    ],
  ),
];
