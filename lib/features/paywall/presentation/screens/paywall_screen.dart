import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_colors.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/data/models/vip_plan.dart';
import 'package:flutter_app_factory_base/data/repositories/baby_data_repository.dart';
import 'package:flutter_app_factory_base/ui/core/widgets/gradient_cta_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _paywallProvider = FutureProvider<_PaywallData>((ref) async {
  final repo = ref.read(babyDataRepositoryProvider);
  final (headline, benefits, plans) = await repo.getVipPlans();
  return _PaywallData(headline: headline, benefits: benefits, plans: plans);
});

class _PaywallData {
  const _PaywallData({
    required this.headline,
    required this.benefits,
    required this.plans,
  });
  final String headline;
  final List<String> benefits;
  final List<VipPlan> plans;
}

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  int _selectedPlanIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_paywallProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => _buildContent(context, data),
      ),
    );
  }

  Widget _buildContent(BuildContext context, _PaywallData data) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: AppMetrics.paywallHeroHeight,
          pinned: true,
          backgroundColor: AppColors.gradientStart,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Icon(Icons.auto_awesome, color: AppColors.white, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'BabyGenie PRO',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Unlock all premium features',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppMetrics.screenPaddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppMetrics.spaceM),
                // Benefits list
                ...data.benefits.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: AppMetrics.spaceS),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: AppMetrics.spaceS),
                        Expanded(
                          child: Text(
                            b,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.onBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppMetrics.spaceL),
                // Plan cards
                if (data.plans.isNotEmpty)
                  ...List.generate(data.plans.length, (i) {
                    final plan = data.plans[i];
                    final isSelected = _selectedPlanIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedPlanIndex = i),
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: AppMetrics.spaceS),
                        padding: const EdgeInsets.all(AppMetrics.spaceM),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryContainer
                              : AppColors.surfaceVariant,
                          borderRadius:
                              BorderRadius.circular(AppMetrics.radiusM),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.outline,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        plan.name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.onBackground,
                                        ),
                                      ),
                                      if (plan.isTrial) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(
                                                    AppMetrics.radiusPill),
                                          ),
                                          child: const Text(
                                            'TRIAL',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (plan.subtitle.isNotEmpty)
                                    Text(
                                      plan.subtitle,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  plan.price,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.onBackground,
                                  ),
                                ),
                                if (plan.note.isNotEmpty)
                                  Text(
                                    plan.note,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: AppMetrics.spaceL),
                GradientCtaButton(
                  key: const ValueKey('btn_paywall_subscribe'),
                  label: 'Continue',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon!')),
                  ),
                ),
                const SizedBox(height: AppMetrics.spaceM),
                const Center(
                  child: Text(
                    'Cancel anytime · Restore purchases',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: AppMetrics.spaceXl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
