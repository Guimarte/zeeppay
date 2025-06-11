import 'package:flutter/material.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/login/presentation/pages/login_page.dart';
import 'package:zeeppay/shared/database/database.dart';

import '../bloc/login_bloc.dart';

mixin LoginPageMixin<T extends StatefulWidget> on State<LoginPage> {
  SettingsPosDataStore get posDataStore => SettingsPosDataStore();
  final loginBloc = getIt.get<LoginBloc>();
  final dataBase = getIt.get<Database>();
  final controllerLogin = TextEditingController();
  final controllerPassword = TextEditingController();
  final String hintTextLogin = "Login";
  final String hintTextPassword = "Senha";
  final TextInputType inputTypeLogin = TextInputType.text;
  final TextInputType inputTypePassword = TextInputType.text;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    _loadSavedLogin();
  }

  void _loadSavedLogin() async {
    final savedUser = dataBase.getString("user");
    final savedPassword = dataBase.getString("password");
    final saveCredentials = dataBase.getBool("saveCredentials");

    if (savedUser != null) controllerLogin.text = savedUser;
    if (savedPassword != null) controllerPassword.text = savedPassword;
    if (saveCredentials) {
      isChecked = true;
    } else {
      isChecked = false;
    }
  }
}
