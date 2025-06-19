import 'package:flutter/material.dart';
import 'package:zeeppay/core/pos_data_store.dart';

class ColorsApp {
  final _posColors = SettingsPosDataStore().settings?.themePos.colors;

  static const _defaultPrimary = Color(0xFF1E88E5);
  static const _defaultSecondary = Color(0xFFB0BEC5);
  static const _defaultBackground = Color(0xFFF5F5F5);
  static const _defaultText = Color(0xFF212121);

  Color get primary => _toColor(_posColors?.primary) ?? _defaultPrimary;
  Color get secondary => _toColor(_posColors?.secondary) ?? _defaultSecondary;
  Color get background =>
      _toColor(_posColors?.background) ?? _defaultBackground;
  Color get text => _toColor(_posColors?.foreground) ?? _defaultText;

  Color get primaryButton => primary;
  Color get primaryButtonText => Colors.white;
  Color get secondaryButton => const Color(0xffECEFF1);
  Color get secondaryButtonText => primary;
  Color get disableButton => const Color(0xffCFD8DC);
  Color get disableButtonText => const Color(0xff90A4AE);
  Color get eraseButtonCard => const Color(0xFFFDE63E);
  Color get confirmButtonCard => const Color(0xFF00A854);

  Color? _toColor(String? hex) {
    if (hex == null) return null;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
