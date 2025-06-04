import 'package:flutter/material.dart';

class CheckBoxWidget extends StatelessWidget {
  CheckBoxWidget({super.key, required this.onChanged, required this.isChecked});
  bool isChecked;
  Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            onChanged(value);
          },
        ),
        const Text('Salvar credenciais', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
