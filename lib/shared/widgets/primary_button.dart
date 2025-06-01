import 'package:flutter/material.dart';
import 'package:zeeppay/theme/colors_app.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonName;
  final Function() functionPrimaryButton;
  const PrimaryButton({
    super.key,
    required this.buttonName,
    required this.functionPrimaryButton,
  });

  @override
  Widget build(BuildContext context) {
    final colorsApp = ColorsApp();
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        onPressed: () {
          functionPrimaryButton();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorsApp.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(buttonName),
      ),
    );
  }
}
