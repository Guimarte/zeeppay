import 'package:flutter/material.dart';

class ButtonNumbersWidget extends StatelessWidget {
  const ButtonNumbersWidget({
    super.key,
    required this.number,
    required this.function,
  });
  final String number;
  final Function(String string) function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function(number);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(number, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
