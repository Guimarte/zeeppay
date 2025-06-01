import 'package:flutter/material.dart';
import 'package:zeeppay/core/routes.dart';
import 'package:zeeppay/theme/theme_app.dart';

class MyApp extends StatelessWidget {
  final Routes routes;
  const MyApp({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zeeppay',
      debugShowCheckedModeBanner: false,
      theme: ThemeApp().themeStandard,
      routerConfig: routes.goRouter,
    );
  }
}
