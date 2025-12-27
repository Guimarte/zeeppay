import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/app/my_app.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/routes.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/flavors/device_detector.dart';

Future<void> main() async {
  FlavorConfig(
    flavor: Flavor.sindbank,
    name: 'SindBank',
    subdomain: 'sindbank',
    deviceModel: DeviceDetector.detectDeviceModel(),
  );
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  setupDependencies(prefs);
  final routes = Routes();
  runApp(MyApp(routes: routes));
}
