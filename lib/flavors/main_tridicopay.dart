import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/app/my_app.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/routes.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

Future<void> main() async {
  FlavorConfig(
    flavor: Flavor.tridicopay,
    name: 'Tridicopay',
    subdomain: 'tridico',
  );
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  setupDependencies(prefs);
  final routes = Routes();
  runApp(MyApp(routes: routes));
}
