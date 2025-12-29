import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zeeppay/core/routes.dart';
import 'package:zeeppay/theme/theme_app.dart';

class MyApp extends StatefulWidget {
  final Routes routes;
  const MyApp({super.key, required this.routes});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Mantém a tela sempre ligada
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Desativa o wakelock quando o app fechar
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zeeppay',
      debugShowCheckedModeBanner: false,
      theme: ThemeApp().themeStandard,
      routerConfig: widget.routes.goRouter,
    );
  }
}
