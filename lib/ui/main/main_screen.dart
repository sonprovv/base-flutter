import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_app_factory_base/features/photo/presentation/screens/photo_screen.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_app_factory_base/features/video/presentation/screens/video_screen.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/exit_app_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialTab = 0});
  final int initialTab;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = widget.initialTab;

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      setState(() => _currentIndex = widget.initialTab);
    }
  }

  static const _tabs = [
    HomeScreen(),
    VideoScreen(),
    PhotoScreen(),
    ProfileScreen(),
  ];

  static const _navIcons = [
    (off: 'assets/images/ic_main_off.png',     on: 'assets/images/ic_main_on.png'),
    (off: 'assets/images/ic_dance_off.png',    on: 'assets/images/ic_dance_on.png'),
    (off: 'assets/images/ic_template_off.png', on: 'assets/images/ic_template_on.png'),
    (off: 'assets/images/ic_mine_off.png',     on: 'assets/images/ic_mine_on.png'),
  ];

  Future<void> _onBackInvoked() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
    } else {
      await ExitAppDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final l10n = context.l10n;
    final navLabels = [l10n.navHome, l10n.navVideo, l10n.navPhoto, l10n.navProfile];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => _onBackInvoked(),
      child: Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        height: AppMetrics.bottomNavHeight + bottomPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: List.generate(_navIcons.length, (i) {
              final selected = i == _currentIndex;
              final icons = _navIcons[i];
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _currentIndex = i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        width: selected ? 24 : 0,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Image.asset(
                        selected ? icons.on : icons.off,
                        width: 24,
                        height: 24,
                        color: selected ? AppColors.primary : null,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        navLabels[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                          color: selected ? AppColors.primary : AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      ),
    );
  }
}
