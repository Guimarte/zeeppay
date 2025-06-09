import 'package:flutter/material.dart';
import 'package:zeeppay/theme/colors_app.dart';

class TextInputCustomLogin extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType textInputType;
  final String hintText;
  final IconData? suffixIcon;
  final Function()? iconFunction;

  const TextInputCustomLogin({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.iconFunction,
  });

  @override
  Widget build(BuildContext context) {
    final colorsApp = ColorsApp();

    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: textInputType,
      cursorColor: colorsApp.primary,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? IconButton(icon: Icon(suffixIcon), onPressed: iconFunction)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorsApp.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorsApp.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorsApp.primary),
        ),
      ),
    );
  }
}
