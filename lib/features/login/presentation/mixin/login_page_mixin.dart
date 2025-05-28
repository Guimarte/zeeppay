import 'package:flutter/material.dart';
import 'package:zeeppay/core/injector.dart';

import '../bloc/login_bloc.dart';

mixin LoginPageMixin {
  final loginBloc = getIt.get<LoginBloc>();
  final controllerLogin = TextEditingController();
  final controllerPassword = TextEditingController();
  final String hintTextLogin = "Login";
  final String hintTextPassword = "Senha";
  final TextInputType inputTypeLogin = TextInputType.text;
  final TextInputType inputTypePassword = TextInputType.numberWithOptions();
}
