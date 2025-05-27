import 'package:flutter/material.dart';
import 'package:zeeppay/theme/colors_app.dart';

final colorsApp = ColorsApp();

class ThemeApp {
  final ThemeData themeStandard = ThemeData(
    primaryColor: colorsApp.background,
    scaffoldBackgroundColor: colorsApp.background,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorsApp.primaryButton),
      ),
    ),
  );
}
