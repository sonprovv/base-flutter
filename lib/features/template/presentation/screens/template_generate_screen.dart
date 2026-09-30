import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_result_dialog.dart';
import 'package:flutter_app_factory_base/features/generate/presentation/widgets/generate_shared.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:go_router/go_router.dart';

class TemplateGenerateScreen extends StatefulWidget {
  const TemplateGenerateScreen({super.key, this.template});

  final TemplateItem? template;

  @override
  State<TemplateGenerateScreen> createState() => _TemplateGenerateScreenState();
}

class _TemplateGenerateScreenState extends State<TemplateGenerateScreen> {
  bool _isBornMode = true;
  String? _babyPhoto;
  String? _motherPhoto;
  String? _fatherPhoto;

  String get _composition =>
      widget.template?.composition.trim().toLowerCase() ?? 'baby_only';

  @override
  void initState() {
    super.initState();
    if (_composition.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final photoPath =
            await context.push<String?>(AppRoute.photoUploadReminder);
        if (photoPath != null && mounted) {
          final t = widget.template;
          final resultAsset = (t != null && t.displayMediaUrl.isNotEmpty)
              ? t.displayMediaUrl
              : photoPath;
          await GenerateResultDialog.show(
            context,
            featureTitle:
                (t != null && t.name.isNotEmpty) ? t.name : 'AI Baby Template',
            resultAsset: resultAsset,
          );
        }
        if (mounted) {
          context.pop();
        }
      });
    }
  }

  bool get _canGenerate {
    if (_composition.isEmpty) {
      return _babyPhoto != null;
    }
    if (_isBornMode) {
      switch (_composition) {
        case 'baby_family':
          return _motherPhoto != null &&
              _fatherPhoto != null &&
              _babyPhoto != null;
        case 'baby_with_mom':
          return _motherPhoto != null && _babyPhoto != null;
        case 'baby_with_dad':
          return _fatherPhoto != null && _babyPhoto != null;
        case 'baby_only':
        default:
          return _babyPhoto != null;
      }
    } else {
      switch (_composition) {
        case 'baby_with_mom':
          return _motherPhoto != null;
        case 'baby_with_dad':
          return _fatherPhoto != null;
        case 'baby_family':
        case 'baby_only':
        default:
          return _motherPhoto != null && _fatherPhoto != null;
      }
    }
  }

  Future<void> _pickPhoto(void Function(String path) onPicked) async {
    final path = await context.push<String?>(AppRoute.photoUploadReminder);
    if (path != null && mounted) {
      setState(() => onPicked(path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final points = widget.template?.points ?? 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back + Points Badge (matches screenshot 20 & 21)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.onBackground,
                      size: 26,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push(AppRoute.paywall),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C5CE7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Segmented Toggle: "Born Baby" | "Unborn Baby"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F7),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isBornMode = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isBornMode ? const Color(0xFF6C5CE7) : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.l10n.bornBaby,
                            style: TextStyle(
                              color: _isBornMode ? Colors.white : AppColors.onBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isBornMode = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_isBornMode ? const Color(0xFF6C5CE7) : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.l10n.unbornBaby,
                            style: TextStyle(
                              color: !_isBornMode ? Colors.white : AppColors.onBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _isBornMode
                    ? _buildBornContent()
                    : _buildUnbornContent(),
              ),
            ),

            // Bottom CTA Button: "Create Now" + Sparkle + points
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: GradientCtaButton(
                height: 56,
                enabled: _canGenerate,
                disabledColor: const Color(0xFFD6D6DE),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF5A48E0)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                label: context.l10n.createNow,
                points: points,
                onTap: _onGeneratePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBornContent() {
    switch (_composition) {
      case 'baby_family':
        return _buildBornBabyFamily();
      case 'baby_with_mom':
        return _buildBornBabyWithMom();
      case 'baby_with_dad':
        return _buildBornBabyWithDad();
      case 'baby_only':
      default:
        return _buildBornBabyOnly();
    }
  }

  Widget _buildBornBabyOnly() {
    return Column(
      children: [
        const SizedBox(height: 12),
        LabeledPicker(
          label: context.l10n.babysPhoto,
          pickedPath: _babyPhoto,
          height: 320,
          onDelete: () => setState(() => _babyPhoto = null),
          onTap: () => _pickPhoto((path) => _babyPhoto = path),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// Exact UI style of Future Family:
  /// Row of Mom's photo + Dad's photo (LabeledPicker) -> CurveArrow() -> Baby's photo (LabeledPicker)
  Widget _buildBornBabyFamily() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledPicker(
                label: context.l10n.momsPhoto,
                pickedPath: _motherPhoto,
                height: 150,
                onDelete: () => setState(() => _motherPhoto = null),
                onTap: () => _pickPhoto((path) => _motherPhoto = path),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: LabeledPicker(
                label: context.l10n.dadsPhoto,
                pickedPath: _fatherPhoto,
                height: 150,
                onDelete: () => setState(() => _fatherPhoto = null),
                onTap: () => _pickPhoto((path) => _fatherPhoto = path),
              ),
            ),
          ],
        ),
        const CurveArrow(),
        LabeledPicker(
          label: context.l10n.babysPhoto,
          pickedPath: _babyPhoto,
          height: 180,
          onDelete: () => setState(() => _babyPhoto = null),
          onTap: () => _pickPhoto((path) => _babyPhoto = path),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBornBabyWithMom() {
    return Column(
      children: [
        const SizedBox(height: 12),
        LabeledPicker(
          label: context.l10n.momsPhoto,
          pickedPath: _motherPhoto,
          height: 170,
          onDelete: () => setState(() => _motherPhoto = null),
          onTap: () => _pickPhoto((path) => _motherPhoto = path),
        ),
        const SizedBox(height: 16),
        LabeledPicker(
          label: context.l10n.babysPhoto,
          pickedPath: _babyPhoto,
          height: 170,
          onDelete: () => setState(() => _babyPhoto = null),
          onTap: () => _pickPhoto((path) => _babyPhoto = path),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBornBabyWithDad() {
    return Column(
      children: [
        const SizedBox(height: 12),
        LabeledPicker(
          label: context.l10n.dadsPhoto,
          pickedPath: _fatherPhoto,
          height: 170,
          onDelete: () => setState(() => _fatherPhoto = null),
          onTap: () => _pickPhoto((path) => _fatherPhoto = path),
        ),
        const SizedBox(height: 16),
        LabeledPicker(
          label: context.l10n.babysPhoto,
          pickedPath: _babyPhoto,
          height: 170,
          onDelete: () => setState(() => _babyPhoto = null),
          onTap: () => _pickPhoto((path) => _babyPhoto = path),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUnbornContent() {
    if (_composition == 'baby_with_mom') {
      return Column(
        children: [
          const SizedBox(height: 12),
          LabeledPicker(
            label: context.l10n.momsPhoto,
            pickedPath: _motherPhoto,
            height: 280,
            onDelete: () => setState(() => _motherPhoto = null),
            onTap: () => _pickPhoto((path) => _motherPhoto = path),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else if (_composition == 'baby_with_dad') {
      return Column(
        children: [
          const SizedBox(height: 12),
          LabeledPicker(
            label: context.l10n.dadsPhoto,
            pickedPath: _fatherPhoto,
            height: 280,
            onDelete: () => setState(() => _fatherPhoto = null),
            onTap: () => _pickPhoto((path) => _fatherPhoto = path),
          ),
          const SizedBox(height: 16),
        ],
      );
    } else {
      // baby_family, baby_only, or default
      return Column(
        children: [
          const SizedBox(height: 12),
          LabeledPicker(
            label: context.l10n.momsPhoto,
            pickedPath: _motherPhoto,
            height: 180,
            onDelete: () => setState(() => _motherPhoto = null),
            onTap: () => _pickPhoto((path) => _motherPhoto = path),
          ),
          const SizedBox(height: 16),
          LabeledPicker(
            label: context.l10n.dadsPhoto,
            pickedPath: _fatherPhoto,
            height: 180,
            onDelete: () => setState(() => _fatherPhoto = null),
            onTap: () => _pickPhoto((path) => _fatherPhoto = path),
          ),
          const SizedBox(height: 24),
        ],
      );
    }
  }

  void _onGeneratePressed() {
    final t = widget.template;
    final resultAsset = (t != null && t.displayMediaUrl.isNotEmpty)
        ? t.displayMediaUrl
        : (_isBornMode
            ? (_babyPhoto ?? 'assets/images/img_gender_baby_girl.png')
            : (_motherPhoto ?? _fatherPhoto ?? 'assets/images/img_gender_baby_girl.png'));
    final featureTitle = (t != null && t.name.isNotEmpty)
        ? t.name
        : 'AI Baby Template';

    unawaited(
      GenerateResultDialog.show(
        context,
        featureTitle: featureTitle,
        resultAsset: resultAsset,
      ),
    );
  }
}
