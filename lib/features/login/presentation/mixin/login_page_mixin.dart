import 'package:flutter/material.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';

import '../bloc/login_bloc.dart';

mixin LoginPageMixin {
  PosDataStore get posDataStore => PosDataStore();
  final loginBloc = getIt.get<LoginBloc>();
  final controllerLogin = TextEditingController();
  final controllerPassword = TextEditingController();
  final String hintTextLogin = "Login";
  final String hintTextPassword = "Senha";
  final TextInputType inputTypeLogin = TextInputType.text;
  final TextInputType inputTypePassword = TextInputType.numberWithOptions();
}
