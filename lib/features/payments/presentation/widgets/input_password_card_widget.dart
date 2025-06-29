import 'package:flutter/material.dart';

class InputPasswordTextFormField extends StatelessWidget {
  const InputPasswordTextFormField({
    super.key,
    required this.controllerPasswordCard,
  });

  final TextEditingController controllerPasswordCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controllerPasswordCard,
      obscureText: true,
      obscuringCharacter: '*',
      readOnly: true,
      textAlign: TextAlign.center,
      style: theme.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: '',
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
