import 'package:flutter/material.dart';

class InputPasswordCardWidget extends StatelessWidget {
  const InputPasswordCardWidget({
    super.key,
    required this.controllerPasswordCard,
  });

  final TextEditingController controllerPasswordCard;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerPasswordCard,
      obscureText: true,
      obscuringCharacter: '*',
      maxLength: 6,
      keyboardType: TextInputType.number,
      showCursor: false,
      decoration: InputDecoration(
        hintText: 'Digite a senha do cartão',
        counterText: '', // remove o contador
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
