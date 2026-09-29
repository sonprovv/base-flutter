import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_app_factory_base/features/photo/presentation/screens/photo_screen.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_app_factory_base/features/video/presentation/screens/video_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _tabs = const [
    HomeScreen(),
    VideoScreen(),
    PhotoScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        height: AppMetrics.bottomNavHeight + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textHint,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/ic_main_off.png', width: 24, height: 24),
                activeIcon: Image.asset('assets/images/ic_main_on.png', width: 24, height: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/ic_dance_off.png', width: 24, height: 24),
                activeIcon: Image.asset('assets/images/ic_dance_on.png', width: 24, height: 24),
                label: 'Video',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/ic_template_off.png', width: 24, height: 24),
                activeIcon: Image.asset('assets/images/ic_template_on.png', width: 24, height: 24),
                label: 'Photo',
              ),
              BottomNavigationBarItem(
                icon: Image.asset('assets/images/ic_mine_off.png', width: 24, height: 24),
                activeIcon: Image.asset('assets/images/ic_mine_on.png', width: 24, height: 24),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
