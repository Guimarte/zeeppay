import 'package:flutter/material.dart';
import 'package:zeeppay/theme/colors_app.dart';

class CheckBoxWidget extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final String label;

  const CheckBoxWidget({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.label = 'Lembrar-me',
  });

  @override
  Widget build(BuildContext context) {
    final colorsApp = ColorsApp();

    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: colorsApp.primary,
      title: Text(label, style: TextStyle(color: colorsApp.text)),
      value: isChecked,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
