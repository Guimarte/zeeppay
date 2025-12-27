import 'package:flutter/material.dart';
import 'package:zeeppay/app/my_app.dart';
import 'package:zeeppay/core/routes.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/flavors/device_detector.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.jbcard,
    name: 'Jbcard',
    subdomain: 'jbcard',
    deviceModel: DeviceDetector.detectDeviceModel(),
  );
  final routes = Routes();

  runApp(MyApp(routes: routes));
}
