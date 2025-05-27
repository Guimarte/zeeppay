import 'package:flutter/material.dart';

mixin LoginPageMixin {
  final controllerLogin = TextEditingController();
  final controllerPassword = TextEditingController();
  final String hintTextLogin = "Login";
  final String hintTextPassword = "Senha";
  final TextInputType inputTypeLogin = TextInputType.text;
  final TextInputType inputTypePassword = TextInputType.numberWithOptions();
}
