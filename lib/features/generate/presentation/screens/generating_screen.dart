import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
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
  });

  final String featureTitle;
  final String momPath;
  final String dadPath;
  final String prompt;

  @override
  ConsumerState<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends ConsumerState<GeneratingScreen> {
  _GenState _genState = _GenState.processing;
  double _progress = 0;
  Timer? _timer;
  int _elapsed = 0;
  static const _totalSeconds = 30;

  @override
  void initState() {
    super.initState();
    _saveProcessingWork();
    _startFakeProgress();
  }

  Future<void> _saveProcessingWork() async {
    final repo = ref.read(babyDataRepositoryProvider);
    final work = ProfileWork(
      id: DateTime.now().millisecondsSinceEpoch,
      name: widget.featureTitle,
      type: 'photo',
      status: 0,
      createdAt: DateTime.now().toIso8601String(),
    );
    await repo.addProfileWork(work);
    _pendingWorkId = work.id;
  }

  int? _pendingWorkId;

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
        _onCompleted();
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
        await repo.updateProfileWork(work.copyWith(status: 1));
      }
    }
    if (mounted) setState(() => _genState = _GenState.completed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _canNav => _genState != _GenState.processing || _elapsed > 0;

  void _goHome() {
    if (!_canNav) {
      _showWait();
      return;
    }
    context.go(AppRoute.main);
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
      SnackBar(content: Text(context.l10n.submittingWait)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          _genState == _GenState.completed
              ? context.l10n.creationCompleted
              : context.l10n.taskSubmission,
          style: const TextStyle(
            fontSize: 17,
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
                children: [
                  const SizedBox(height: AppMetrics.spaceM),
                  _StatusCard(
                    genState: _genState,
                    progress: _progress,
                    featureTitle: widget.featureTitle,
                    onAction: _onAction,
                  ),
                  const SizedBox(height: AppMetrics.spaceXl),
                ],
              ),
            ),
          ),
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
        context.push(AppRoute.paywall);
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
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppMetrics.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
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
                    : _CircularProgress(value: progress),
          ),
          const SizedBox(height: 28),
          Text(
            isCompleted
                ? context.l10n.completed
                : isFailed
                    ? context.l10n.generationFailed
                    : context.l10n.generationOnTheWay(featureTitle),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
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
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: 160,
            height: 44,
            child: FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
                ),
              ),
              child: Text(
                isCompleted
                    ? context.l10n.viewNow
                    : isFailed
                        ? context.l10n.goBack
                        : context.l10n.buyPoints,
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

class _CircularProgress extends StatelessWidget {
  const _CircularProgress({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: 8,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        Text(
          '${(value * 100).round()}%',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CompleteIcon extends StatelessWidget {
  const _CompleteIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withAlpha(20),
      ),
      child: Image.asset(
        'assets/images/ic_temp_complete.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.check_circle_outline_rounded,
          size: 80,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _FailIcon extends StatelessWidget {
  const _FailIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.error.withAlpha(20),
      ),
      child: Image.asset(
        'assets/images/ic_temp_fail.png',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.error_outline_rounded,
          size: 80,
          color: AppColors.error,
        ),
      ),
    );
  }
}

// ── Bottom buttons ─────────────────────────────────────────────────────────────

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
      padding: EdgeInsets.fromLTRB(
        AppMetrics.screenPaddingHorizontal,
        4,
        AppMetrics.screenPaddingHorizontal,
        4 + bottomPadding,
      ),
      height: 50 + 8 + bottomPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
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
          const SizedBox(width: 8),
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
        decoration: BoxDecoration(
          color: const Color(0xFFEEE9FD),
          borderRadius: BorderRadius.circular(AppMetrics.radiusM),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_outlined, size: 20, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
