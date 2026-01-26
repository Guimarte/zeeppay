import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/app/my_app.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/routes.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig(flavor: Flavor.devee, name: 'Devee', subdomain: 'devee');

  // Configurar cache de imagens com limite
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB

  final prefs = await SharedPreferences.getInstance();
  setupDependencies(prefs);
  final routes = Routes();
  runApp(MyApp(routes: routes));
}
