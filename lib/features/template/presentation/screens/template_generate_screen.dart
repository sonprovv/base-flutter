import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/data/models/template_item.dart';
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

  bool get _canGenerate {
    if (_isBornMode) {
      return _babyPhoto != null;
    } else {
      return _motherPhoto != null && _fatherPhoto != null;
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
                            'Born Baby',
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
                            'Unborn Baby',
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isBornMode
                    ? _buildBornContent()
                    : _buildUnbornContent(),
              ),
            ),

            // Bottom CTA Button: "Create Now" + Sparkle + points
            Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: _canGenerate
                    ? const LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFF5A48E0)],
                      )
                    : null,
                color: _canGenerate ? null : const Color(0xFFD6D6DE),
                borderRadius: BorderRadius.circular(28),
                boxShadow: _canGenerate
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6C5CE7).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _canGenerate ? _onGeneratePressed : null,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'Create Now',
                        style: TextStyle(
                          color: _canGenerate ? Colors.white : Colors.white.withValues(alpha: 0.8),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: _canGenerate ? Colors.white : Colors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$points',
                                style: TextStyle(
                                  color: _canGenerate ? Colors.white : Colors.white.withValues(alpha: 0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBornContent() {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Baby's Photo",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 16),
        _buildUploadCard(
          height: 320,
          photoPath: _babyPhoto,
          onTap: () {
            // Pick or toggle demo sample photo
            setState(() {
              _babyPhoto = _babyPhoto == null ? 'assets/images/ic_main_future_baby.png' : null;
            });
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUnbornContent() {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "Mother's Photo",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        _buildUploadCard(
          height: 180,
          photoPath: _motherPhoto,
          onTap: () {
            setState(() {
              _motherPhoto = _motherPhoto == null ? 'assets/images/gender_baby_girl.png' : null;
            });
          },
        ),
        const SizedBox(height: 20),
        const Text(
          "Father's Photo",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 12),
        _buildUploadCard(
          height: 180,
          photoPath: _fatherPhoto,
          onTap: () {
            setState(() {
              _fatherPhoto = _fatherPhoto == null ? 'assets/images/gender_baby_boy.png' : null;
            });
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildUploadCard({
    required double height,
    required String? photoPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEEEF3), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: photoPath != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      photoPath,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Center(
                        child: Icon(Icons.check_circle, color: Color(0xFF6C5CE7), size: 48),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                        color: Color(0xFF9E9EB0),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Upload Photo',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9E9EB0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _onGeneratePressed() {
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
                ),
                SizedBox(height: 20),
                Text(
                  'Generating AI Baby...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Analyzing facial features and generating result',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    unawaited(
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Generation complete! Saved to your creations.'),
              backgroundColor: Color(0xFF6C5CE7),
            ),
          );
        }
      }),
    );
  }
}
