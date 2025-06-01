import 'package:flutter/material.dart';
import 'package:zeeppay/core/routes.dart';

class MyApp extends StatelessWidget {
  final Routes routes;
  const MyApp({super.key, required this.routes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: Routes().goRouter,
    );
  }
}
