import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/features/profile/domain/entities/profile.dart';
import 'package:flutter_app_factory_base/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Example: Profile')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileViewModelProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppMetrics.spaceXl),
          children: [
            profile.when(
              data: (value) => _ProfileCard(profile: value),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppMetrics.spaceXxl),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => _ErrorView(
                message: 'Unable to load profile. Pull to retry.',
                onRetry: () {
                  unawaited(
                    ref.read(profileViewModelProvider.notifier).refresh(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppMetrics.spaceXs),
            Text(profile.email),
            const SizedBox(height: AppMetrics.spaceM),
            const Text(
              'Flow: Screen → ViewModel → UseCase → Repository → DataSource → API',
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppMetrics.spaceS),
          OutlinedButton(
            key: const ValueKey('btn_profile_retry'),
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
