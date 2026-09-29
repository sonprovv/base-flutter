import 'package:flutter/material.dart';
import 'package:flutter_app_factory_base/app/app.dart';
import 'package:flutter_app_factory_base/core/config/app_config.dart';
import 'package:flutter_app_factory_base/core/config/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the base home screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            const AppConfig(
              flavor: AppFlavor.dev,
              apiBaseUrl: 'https://example.invalid',
              enableNetworkLogs: false,
            ),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Flutter App Factory Base'), findsOneWidget);
    expect(find.byKey(const ValueKey('btn_home_profile')), findsOneWidget);
  });
}
