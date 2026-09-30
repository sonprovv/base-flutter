import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _GenState { processing, completed, failed }

class GeneratingScreen extends ConsumerStatefulWidget {
  const GeneratingScreen({
    super.key,
    required this.featureTitle,
    required this.momPath,
    required this.dadPath,
    required this.prompt,
    this.resultAsset,
  });

  final String featureTitle;
  final String momPath;
  final String dadPath;
  final String prompt;
  final String? resultAsset;

  @override
  ConsumerState<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends ConsumerState<GeneratingScreen> {
  _GenState _genState = _GenState.processing;
  double _progress = 0;
  Timer? _timer;
  int _elapsed = 0;
  // A snappy fake progress duration for great demo experience (12 seconds)
  static const _totalSeconds = 12;

  int? _pendingWorkId;
  bool _isSubmitting = true;

  @override
  void initState() {
    super.initState();
    unawaited(_saveProcessingWork());
    // Simulate brief initial submission phase, then fake progress
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _startFakeProgress();
      }
    });
  }

  Future<void> _saveProcessingWork() async {
    final repo = ref.read(babyDataRepositoryProvider);
    final fallbackAsset = widget.resultAsset ??
        'assets/images/img_gender_baby_girl.png';
    final work = ProfileWork(
      id: DateTime.now().millisecondsSinceEpoch,
      name: widget.featureTitle,
      type: 'photo',
      status: 0,
      coverUrl: fallbackAsset,
      mediaUrl: fallbackAsset,
      createdAt: DateTime.now().toIso8601String(),
    );
    await repo.addProfileWork(work);
    _pendingWorkId = work.id;
  }

  void _startFakeProgress() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      _elapsed++;
      final p = (_elapsed / _totalSeconds).clamp(0.0, 1.0);
      setState(() => _progress = p);
      if (_elapsed >= _totalSeconds) {
        t.cancel();
        unawaited(_onCompleted());
      }
    });
  }

  Future<void> _onCompleted() async {
    final id = _pendingWorkId;
    if (id != null) {
      final repo = ref.read(babyDataRepositoryProvider);
      final all = await repo.getProfileWorks();
      final work = all.where((w) => w.id == id).firstOrNull;
      if (work != null) {
        final fallbackAsset = widget.resultAsset ??
            'assets/images/img_gender_baby_girl.png';
        await repo.updateProfileWork(
          work.copyWith(
            status: 1,
            coverUrl: fallbackAsset,
            mediaUrl: fallbackAsset,
          ),
        );
      }
    }
    if (mounted) {
      setState(() => _genState = _GenState.completed);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _canNav => !_isSubmitting;

  void _goHome() {
    if (!_canNav) {
      _showWait();
      return;
    }
    context.go(AppRoute.main, extra: {'tab': 0});
  }

  void _goMyPhoto() {
    if (!_canNav) {
      _showWait();
      return;
    }
    context.go(AppRoute.main, extra: {'tab': 3});
  }

  void _showWait() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.submittingWait),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final homeState = ref.watch(homeViewModelProvider);

    // Get recommend trending templates
    final categories = homeState.asData?.value.categories ?? const [];
    final trendingTemplates = categories
            .where((c) => c.templates.isNotEmpty)
            .firstOrNull
            ?.templates ??
        const <TemplateItem>[];

    final title = switch (_genState) {
      _GenState.completed => context.l10n.creationCompleted,
      _GenState.failed => context.l10n.generationFailed,
      _GenState.processing => _isSubmitting
          ? context.l10n.taskSubmission
          : 'Submission successful',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/icon_arrow_left_black.png',
            width: 24,
            height: 24,
            errorBuilder: (_, _, _) => const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () {
            if (!_canNav) {
              _showWait();
              return;
            }
            context.pop();
          },
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF181818),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Main Status Card
                  _StatusCard(
                    genState: _genState,
                    progress: _progress,
                    featureTitle: widget.featureTitle,
                    onAction: _onAction,
                  ),
                  const SizedBox(height: 24),
                  // Trending section header
                  GestureDetector(
                    onTap: () {
                      if (!_canNav) {
                        _showWait();
                        return;
                      }
                      unawaited(
                        context.push(
                          AppRoute.templateList,
                          extra: {'category': 'Trending'},
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Trending',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF181818),
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          'assets/images/icon_right_arrow_gray.png',
                          width: 18,
                          height: 18,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF888888),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Trending horizontal carousel
                  if (trendingTemplates.isNotEmpty)
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: trendingTemplates.length,
                        itemBuilder: (context, index) {
                          final template = trendingTemplates[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: _TrendingCard(
                              template: template,
                              onTap: () {
                                if (!_canNav) {
                                  _showWait();
                                  return;
                                }
                                if (template.isVideo) {
                                  unawaited(
                                    context.push(
                                      AppRoute.danceDetail,
                                      extra: template,
                                    ),
                                  );
                                } else {
                                  unawaited(
                                    context.push(
                                      AppRoute.photoDetail,
                                      extra: template,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const SizedBox(height: 120),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Bottom persistent buttons: Home and My Photo
          _BottomButtons(
            onHome: _goHome,
            onMyPhoto: _goMyPhoto,
            bottomPadding: bottomPadding,
          ),
        ],
      ),
    );
  }

  void _onAction() {
    switch (_genState) {
      case _GenState.completed:
        _goMyPhoto();
      case _GenState.failed:
        context.pop();
      case _GenState.processing:
        unawaited(context.push(AppRoute.paywall));
    }
  }
}

// ── Status card ────────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.genState,
    required this.progress,
    required this.featureTitle,
    required this.onAction,
  });

  final _GenState genState;
  final double progress;
  final String featureTitle;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final isCompleted = genState == _GenState.completed;
    final isFailed = genState == _GenState.failed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: isCompleted
                ? const _CompleteIcon()
                : isFailed
                    ? const _FailIcon()
                    : _FakeCircularProgress(progress: progress),
          ),
          const SizedBox(height: 24),
          Text(
            isCompleted
                ? context.l10n.completed
                : isFailed
                    ? context.l10n.generationFailed
                    : 'Your $featureTitle is on the way ✨',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF181818),
            ),
          ),
          if (!isCompleted) ...[
            const SizedBox(height: 6),
            Text(
              isFailed
                  ? context.l10n.somethingWentWrong
                  : context.l10n.generationWaitMsg,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: 160,
            height: 44,
            child: isFailed
                ? OutlinedButton(
                    onPressed: onAction,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF583FFE),
                      side: const BorderSide(
                        color: Color(0xFF583FFE),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      context.l10n.goBack,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : FilledButton(
                    onPressed: onAction,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF583FFE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      isCompleted
                          ? context.l10n.viewNow
                          : '💎 Buy Points',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Custom Circular Progress matching BabyGenie FakeCircularProgressView ────────

class _FakeCircularProgress extends StatelessWidget {
  const _FakeCircularProgress({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CircularProgressPainter(progress: progress),
      child: Center(
        child: Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF181818),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 7.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = const Color(0xFFEDEDED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = const Color(0xFF583FFE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.141592653589793 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _CompleteIcon extends StatelessWidget {
  const _CompleteIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/ic_temp_complete.png',
        width: 86,
        height: 86,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(
          Icons.check_circle_rounded,
          size: 80,
          color: Color(0xFF583FFE),
        ),
      ),
    );
  }
}

class _FailIcon extends StatelessWidget {
  const _FailIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/ic_temp_fail.png',
        width: 86,
        height: 86,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(
          Icons.error_outline_rounded,
          size: 80,
          color: AppColors.error,
        ),
      ),
    );
  }
}

// ── Trending Card ──────────────────────────────────────────────────────────────

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.template, required this.onTap});
  final TemplateItem template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 168,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildCover(),
              // Title gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black87,
                      ],
                    ),
                  ),
                  child: Text(
                    template.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (template.isVideo)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(120),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/icon_showvideo_play.png',
                      width: 14,
                      height: 14,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 14,
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

  Widget _buildCover() {
    final url = template.coverUrl.isNotEmpty
        ? template.coverUrl
        : template.previewWebpUrl;
    if (url.startsWith('assets/')) {
      return Image.asset(url, fit: BoxFit.cover);
    }
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: AppColors.surfaceVariant,
          child: const Icon(Icons.image, color: Color(0xFFAAAAAA)),
        ),
      );
    }
    return Container(
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.image, color: Color(0xFFAAAAAA)),
    );
  }
}

// ── Bottom buttons matching BabyGenie ──────────────────────────────────────────

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    required this.onHome,
    required this.onMyPhoto,
    required this.bottomPadding,
  });

  final VoidCallback onHome;
  final VoidCallback onMyPhoto;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 6, 15, 6 + bottomPadding),
      height: 50 + 12 + bottomPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomBtn(
              assetPath: 'assets/images/ic_template_home.png',
              label: context.l10n.navHome,
              onTap: onHome,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _BottomBtn(
              assetPath: 'assets/images/ic_template_my_photo.png',
              label: context.l10n.myPhoto,
              onTap: onMyPhoto,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBtn extends StatelessWidget {
  const _BottomBtn({
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  final String assetPath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFEEE9FD),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.home_outlined,
                size: 20,
                color: Color(0xFF181818),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF181818),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
