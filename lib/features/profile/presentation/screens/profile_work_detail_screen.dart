import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/profile_work.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileWorkDetailScreen extends ConsumerWidget {
  const ProfileWorkDetailScreen({super.key, required this.work});
  final ProfileWork work;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF181818),
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
              color: Color(0xFF181818),
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Production Record',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF181818),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
              color: Color(0xFF181818),
              size: 26,
            ),
            onPressed: () => _showMoreMenu(context, ref),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Main media shell
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _MediaView(work: work),
                  ),
                ),
              ),
            ),
          ),
          // Save to Phone CTA
          _SaveButton(
            onTap: () => _save(context),
            bottomPadding: bottomPadding,
          ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Saved to gallery'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMoreMenu(BuildContext context, WidgetRef ref) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.report_problem_outlined,
                    color: Color(0xFF181818),
                    size: 22,
                  ),
                  title: const Text(
                    'Report',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF181818),
                    ),
                  ),
                  onTap: () {
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Report submitted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(ctx);
                  },
                ),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                ListTile(
                  leading: Image.asset(
                    'assets/images/ic_profile_delete.png',
                    width: 22,
                    height: 22,
                    color: const Color(0xFFF95659),
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFF95659),
                      size: 22,
                    ),
                  ),
                  title: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF95659),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmDelete(context, ref);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text('Delete this work? It cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await ref.read(babyDataRepositoryProvider).removeProfileWork(work.id);
              if (context.mounted) {
                context.pop();
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ));
  }
}

// ── Media view ─────────────────────────────────────────────────────────────────

class _MediaView extends StatelessWidget {
  const _MediaView({required this.work});
  final ProfileWork work;

  @override
  Widget build(BuildContext context) {
    final path = work.mediaUrl.isNotEmpty
        ? work.mediaUrl
        : (work.coverUrl.isNotEmpty ? work.coverUrl : work.previewWebpUrl);

    if (path.isEmpty) {
      return _buildPlaceholder();
    }

    Widget content;
    if (path.startsWith('assets/')) {
      content = Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildPlaceholder(),
      );
    } else if (path.startsWith('http') || path.startsWith('blob:') || kIsWeb) {
      content = Image.network(
        path,
        fit: BoxFit.contain,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF583FFE)),
            ),
          );
        },
        errorBuilder: (_, _, _) => _buildPlaceholder(),
      );
    } else {
      content = Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildPlaceholder(),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: content),
        if (work.isVideo)
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(120),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/icon_showvideo_play.png',
                width: 36,
                height: 36,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.play_arrow,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5F6F9),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: Color(0xFFAAAAAA),
        ),
      ),
    );
  }
}

// ── Save button ────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onTap, required this.bottomPadding});
  final VoidCallback onTap;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        24 + bottomPadding,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF583FFE),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: const Text(
            'Save to Phone',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
