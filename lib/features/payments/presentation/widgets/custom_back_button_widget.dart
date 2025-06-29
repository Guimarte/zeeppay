import 'package:flutter/material.dart';

class CustomBackButtonWidget extends StatelessWidget {
  const CustomBackButtonWidget({super.key, required this.backButton});

  final Function() backButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            backButton();
          },
        ),
      ],
    );
  }
}
