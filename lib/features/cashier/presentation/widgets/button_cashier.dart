import 'package:flutter/material.dart';

class ButtonCashier extends StatelessWidget {
  final Function() function;
  const ButtonCashier({required this.function, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
      ),
      child: SizedBox(
        child: Center(child: Text("Fechar")),
        width: double.infinity,
      ),
    );
  }
}
