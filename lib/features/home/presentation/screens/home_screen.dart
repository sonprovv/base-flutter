import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/router/app_router.dart';
import 'package:flutter_app_factory_base/app/theme/app_metrics.dart';
import 'package:flutter_app_factory_base/core/config/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter App Factory Base')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppMetrics.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.all(AppMetrics.spaceXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Environment: ${config.flavor.name}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppMetrics.spaceXs),
                Text('API: ${config.apiBaseUrl}'),
                const SizedBox(height: AppMetrics.spaceXl),
                FilledButton(
                  key: const ValueKey('btn_home_profile'),
                  onPressed: () {
                    unawaited(context.push(AppRoute.profile));
                  },
                  child: const Text('Open example feature'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
