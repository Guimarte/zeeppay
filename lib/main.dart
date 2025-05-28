import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zeeppay/app/my_app.dart';
import 'package:zeeppay/core/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  setupDependencies(prefs);
  runApp(const MyApp());
}
