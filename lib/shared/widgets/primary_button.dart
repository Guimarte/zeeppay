import 'package:flutter/material.dart';
import 'package:zeeppay/theme/colors_app.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonName;
  final Function() functionPrimaryButton;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.buttonName,
    required this.functionPrimaryButton,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colorsApp = ColorsApp();

    return SizedBox(
      width: width ?? double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: functionPrimaryButton,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorsApp.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text(buttonName, style: TextStyle(color: colorsApp.text)),
      ),
    );
  }
}
