import 'package:flutter/material.dart';

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
    return SizedBox(
      width: 120,
      child: ElevatedButton(
        onPressed: () {
          functionPrimaryButton();
        },
        child: Text(buttonName),
      ),
    );
  }
}
