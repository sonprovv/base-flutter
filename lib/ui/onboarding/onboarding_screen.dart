import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class _OnboardingPage {

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.gradientColors,
  });
  final String title;
  final String description;
  final List<Color> gradientColors;
}

const _pages = [
  _OnboardingPage(
    title: 'Discover Your\nFuture Baby',
    description: 'See what your baby will look like with AI-powered face generation',
    gradientColors: [Color(0xFF6662FE), Color(0xFFA448FF)],
  ),
  _OnboardingPage(
    title: 'Baby Dance\nTemplates',
    description: 'Create adorable dance videos with your baby using trending templates',
    gradientColors: [Color(0xFFFF6100), Color(0xFFFF9500)],
  ),
  _OnboardingPage(
    title: 'Family\nSimilarity',
    description: 'Discover who your baby looks like most with our similarity detection',
    gradientColors: [Color(0xFF00C897), Color(0xFF00A3FF)],
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    final prefs = ref.read(prefsServiceProvider);
    prefs.isCompletedOnboarding = true;
    context.go(AppRoute.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) => _PageView(page: _pages[index]),
          ),
          // Bottom overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppMetrics.spaceXl,
                  AppMetrics.spaceM,
                  AppMetrics.spaceXl,
                  AppMetrics.spaceM,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _pages.length,
                      effect: const WormEffect(
                        dotColor: Colors.white38,
                        activeDotColor: AppColors.primary,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    SizedBox(
                      width: double.infinity,
                      height: AppMetrics.buttonHeight,
                      child: FilledButton.icon(
                        onPressed: _onNext,
                        icon: _currentPage == _pages.length - 1
                            ? const SizedBox.shrink()
                            : const Icon(Icons.chevron_right),
                        label: Text(
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppMetrics.radiusPill),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceM),
                    const Text(
                      'By continuing, you agree to our Terms & Privacy Policy',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageView extends StatelessWidget {

  const _PageView({required this.page});
  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: page.gradientColors,
            ),
          ),
        ),
        // Fade to dark at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC000000)],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          left: AppMetrics.screenPaddingHorizontal,
          right: AppMetrics.screenPaddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceS),
              Text(
                page.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.white,
                  height: 1.4,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
