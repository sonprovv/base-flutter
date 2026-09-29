import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/photo_picker_widget.dart';

class UltrasoundViewerScreen extends StatefulWidget {
  const UltrasoundViewerScreen({super.key});

  @override
  State<UltrasoundViewerScreen> createState() => _UltrasoundViewerScreenState();
}

class _UltrasoundViewerScreenState extends State<UltrasoundViewerScreen> {
  int _selectedGender = 0; // 0=Boy, 1=Girl
  int _selectedSkinTone = 0;

  static const _skinTones = [
    AppColors.skinTone1,
    AppColors.skinTone2,
    AppColors.skinTone3,
    AppColors.skinTone4,
  ];

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.onBackground),
        title: const Text(
          'Ultrasound Viewer',
          style: TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upload an ultrasound image to visualize your baby',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceL),
              // Gender toggle
              const Text(
                'Baby Gender',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceS),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
                ),
                child: Row(
                  children: [
                    _GenderToggleButton(
                      label: 'Boy',
                      isSelected: _selectedGender == 0,
                      color: const Color(0xFF90CAF9),
                      onTap: () => setState(() => _selectedGender = 0),
                    ),
                    _GenderToggleButton(
                      label: 'Girl',
                      isSelected: _selectedGender == 1,
                      color: AppColors.genderGirlBorder,
                      onTap: () => setState(() => _selectedGender = 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppMetrics.spaceL),
              // Skin tone selector
              const Text(
                'Skin Tone',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceS),
              Row(
                children: List.generate(_skinTones.length, (i) {
                  final selected = _selectedSkinTone == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSkinTone = i),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: AppMetrics.spaceS),
                      decoration: BoxDecoration(
                        color: _skinTones[i],
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(
                                color: AppColors.primary,
                                width: 3,
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppMetrics.spaceL),
              // Photo picker
              PhotoPickerWidget(
                key: const ValueKey('picker_ultrasound'),
                label: 'Upload Ultrasound Image',
                icon: Icons.image_outlined,
                onTap: _showComingSoon,
              ),
              const SizedBox(height: AppMetrics.spaceXl),
              GradientCtaButton(
                key: const ValueKey('btn_ultrasound_generate'),
                label: 'Visualize Baby',
                onTap: _showComingSoon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderToggleButton extends StatelessWidget {

  const _GenderToggleButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppMetrics.spaceS),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(200) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.onSurfaceVariant,
              fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
