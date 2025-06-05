import 'package:flutter/material.dart';

class DigitalKeyboard extends StatelessWidget {
  const DigitalKeyboard({
    super.key,
    required this.numbers,
    required this.controller,
    required this.confirmButton,
    required this.eraseButton,
    required this.numberButton,
  });

  final List<String> numbers;
  final TextEditingController controller;
  final Widget confirmButton;
  final Widget eraseButton;
  final Widget Function(String) numberButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.7,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          physics: NeverScrollableScrollPhysics(),
          children: numbers.map((e) {
            switch (e) {
              case ('erase'):
                return eraseButton;
              case ('confirm'):
                return confirmButton;
              default:
                return numberButton(e);
            }
          }).toList(),
        ),
      ),
    );
  }
}
