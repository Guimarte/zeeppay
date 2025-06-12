import 'package:flutter/material.dart';

class PaymentValueTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const PaymentValueTextFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      readOnly: true,
      textAlign: TextAlign.center,
      style: theme.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'R\$ 0,00',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
      ),
    );
  }
}
