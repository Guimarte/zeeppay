import 'package:flutter/material.dart';
import 'package:zeeppay/app/my_app.dart';
import 'package:zeeppay/core/routes.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

void main() {
  FlavorConfig(flavor: Flavor.yano, name: 'Yano', subdomain: 'yano');
  final routes = Routes();

  runApp(MyApp(routes: routes));
}
