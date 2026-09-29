import 'package:flutter_app_factory_base/app/bootstrap.dart';
import 'package:flutter_app_factory_base/core/config/app_config.dart';

Future<void> main() async {
  await bootstrap(AppConfig.fromEnvironment());
}
