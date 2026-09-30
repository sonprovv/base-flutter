import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/core/storage/prefs_service.dart';
import 'package:flutter_app_factory_base/l10n/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.assetPath,
    required this.getTitle,
    required this.getDesc,
  });
  final String assetPath;
  final String Function(BuildContext) getTitle;
  final String Function(BuildContext) getDesc;
}

List<_OnboardingPage> _buildPages() => [
  _OnboardingPage(
    assetPath: 'assets/images/guide_video_pic1.png',
    getTitle: (ctx) => ctx.l10n.onboarding1Title,
    getDesc: (ctx) => ctx.l10n.onboarding1Desc,
  ),
  _OnboardingPage(
    assetPath: 'assets/images/guide_video_pic2.png',
    getTitle: (ctx) => ctx.l10n.onboarding2Title,
    getDesc: (ctx) => ctx.l10n.onboarding2Desc,
  ),
  _OnboardingPage(
    assetPath: 'assets/images/guide_video_pic3.png',
    getTitle: (ctx) => ctx.l10n.onboarding3Title,
    getDesc: (ctx) => ctx.l10n.onboarding3Desc,
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
  late final List<_OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();
    _pages = _buildPages();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    ref.read(prefsServiceProvider).isCompletedOnboarding = true;
    context.go(AppRoute.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) => _HeroPage(page: _pages[index]),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + AppMetrics.spaceS,
            right: AppMetrics.screenPaddingHorizontal,
            child: AnimatedOpacity(
              opacity: _currentPage < _pages.length - 1 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: TextButton(
                onPressed: _currentPage < _pages.length - 1 ? _finish : null,
                child: Text(
                  context.l10n.skip,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppMetrics.spaceXl,
                  0,
                  AppMetrics.spaceXl,
                  AppMetrics.spaceM,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _pages.length,
                      effect: const ExpandingDotsEffect(
                        dotColor: Colors.white38,
                        activeDotColor: AppColors.white,
                        dotHeight: 6,
                        dotWidth: 6,
                        expansionFactor: 4,
                        spacing: 5,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceL),

                    SizedBox(
                      width: double.infinity,
                      height: AppMetrics.buttonHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.gradientStart, AppColors.gradientEnd],
                          ),
                          borderRadius:
                              BorderRadius.circular(AppMetrics.radiusPill),
                        ),
                        child: FilledButton(
                          onPressed: _onNext,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppMetrics.radiusPill),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? context.l10n.getStarted
                                : context.l10n.next,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spaceS),

                    Text(
                      context.l10n.termsAgreement,
                      style: const TextStyle(fontSize: 11, color: Colors.white54),
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

class _HeroPage extends StatelessWidget {
  const _HeroPage({required this.page});
  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          page.assetPath,
          fit: BoxFit.cover,
          width: size.width,
          height: size.height,
          errorBuilder: (_, __, ___) =>
              const ColoredBox(color: Color(0xFF1A1A2E)),
        ),

        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC000000), Colors.transparent],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: size.height * 0.55,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xF0000000)],
                stops: [0.0, 0.8],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 175,
          left: AppMetrics.screenPaddingHorizontal,
          right: AppMetrics.screenPaddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                page.getTitle(context),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppMetrics.spaceS),
              Text(
                page.getDesc(context),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
