enum AppFlavor { dev, staging, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.enableNetworkLogs,
  });

  factory AppConfig.fromEnvironment() {
    const rawFlavor = String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'dev',
    );
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://example.invalid',
    );
    const enableNetworkLogs = bool.fromEnvironment(
      'ENABLE_NETWORK_LOGS',
      defaultValue: true,
    );

    final flavor = switch (rawFlavor) {
      'prod' => AppFlavor.prod,
      'staging' => AppFlavor.staging,
      _ => AppFlavor.dev,
    };

    return AppConfig(
      flavor: flavor,
      apiBaseUrl: apiBaseUrl,
      enableNetworkLogs: enableNetworkLogs,
    );
  }

  final AppFlavor flavor;
  final String apiBaseUrl;
  final bool enableNetworkLogs;

  bool get isProduction => flavor == AppFlavor.prod;
}
