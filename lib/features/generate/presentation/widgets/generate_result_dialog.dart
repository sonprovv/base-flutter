import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Unified Generate Flow Dialog:
/// 1. Shows Loading Dialog ("Generating AI Baby...")
/// 2. Seamlessly transitions to Preview Output
/// 3. Provides "Save" and "Not now" actions
/// 4. Both actions navigate to Home (`AppRoute.main`, tab: 0)
class GenerateResultDialog extends ConsumerStatefulWidget {
  const GenerateResultDialog({
    super.key,
    required this.featureTitle,
    required this.resultAsset,
  });

  final String featureTitle;
  final String resultAsset;

  static Future<void> show(
    BuildContext context, {
    required String featureTitle,
    required String resultAsset,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => GenerateResultDialog(
        featureTitle: featureTitle,
        resultAsset: resultAsset,
      ),
    );
  }

  @override
  ConsumerState<GenerateResultDialog> createState() =>
      _GenerateResultDialogState();
}

class _GenerateResultDialogState extends ConsumerState<GenerateResultDialog> {
  bool _isLoading = true;
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate generation with smooth progress bar
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _progress += 0.025; // Completes in ~2.0s
        if (_progress >= 1.0) {
          _progress = 1.0;
          _isLoading = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _saveAndGoHome() async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final successMsg = context.l10n.generationComplete;

    try {
      final repo = ref.read(babyDataRepositoryProvider);
      final work = ProfileWork(
        id: DateTime.now().millisecondsSinceEpoch,
        name: widget.featureTitle,
        type: 'photo',
        status: 1,
        coverUrl: widget.resultAsset,
        mediaUrl: widget.resultAsset,
        createdAt: DateTime.now().toIso8601String(),
      );
      await repo.addProfileWork(work);
    } catch (_) {}

    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pop();
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(successMsg),
        backgroundColor: const Color(0xFF6C5CE7),
        duration: const Duration(seconds: 2),
      ),
    );
    router.go(AppRoute.main, extra: {'tab': 0});
  }

  void _goHome() {
    final router = GoRouter.of(context);
    Navigator.of(context, rootNavigator: true).pop();
    router.go(AppRoute.main, extra: {'tab': 0});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 360),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoading ? _buildLoading(context) : _buildPreview(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Padding(
      key: const ValueKey('loading_view'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 32,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.generatingAiBaby,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.analyzingFacialFeatures,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 180,
              height: 6,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.primaryContainer,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    return Padding(
      key: const ValueKey('preview_view'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Title + Close Button
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.featureTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close,
                    size: 22, color: AppColors.onSurfaceVariant),
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: _goHome,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Output preview image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F5FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildOutputImage(widget.resultAsset),
            ),
          ),
          const SizedBox(height: 20),
          // Save Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF5A48E0)],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _saveAndGoHome,
                icon: const Icon(Icons.download_rounded,
                    color: Colors.white, size: 20),
                label: Text(
                  context.l10n.save,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Not now Button
          TextButton(
            onPressed: _goHome,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: const Text(
              'Not now',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF888888),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputImage(String path) {
    if (path.startsWith('http') || (kIsWeb && path.startsWith('blob:'))) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Center(
          child: Icon(Icons.broken_image,
              size: 48, color: AppColors.textSecondary),
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(Icons.broken_image,
            size: 48, color: AppColors.textSecondary),
      ),
    );
  }
}
