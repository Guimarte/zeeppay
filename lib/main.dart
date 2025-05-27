import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/routes.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  setupDependencies(prefs);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
