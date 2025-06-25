import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_bloc.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_event.dart';
import 'package:zeeppay/features/login/presentation/mixin/login_page_mixin.dart';
import 'package:zeeppay/features/login/presentation/widgets/check_box.dart';
import 'package:zeeppay/features/login/presentation/widgets/text_input_custom_login.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';
import 'package:zeeppay/shared/widgets/primary_button.dart';
import 'package:zeeppay/shared/widgets/show_dialog_erro_widget.dart';
import 'package:zeeppay/shared/widgets/show_dialog_loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginPageMixin {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: posDataStore.settings!.themePos.logo,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 48, color: Colors.red),
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                TextInputCustomLogin(
                  controller: controllerLogin,
                  isPassword: false,
                  hintText: hintTextLogin,
                  textInputType: inputTypeLogin,
                  suffixIcon: Icons.person,
                  iconFunction: () {},
                ),
                const SizedBox(height: 16),
                TextInputCustomLogin(
                  controller: controllerPassword,
                  isPassword: _obscurePassword,
                  hintText: hintTextPassword,
                  textInputType: inputTypePassword,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  iconFunction: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<LoginBloc, CommonState>(
                  bloc: loginBloc,
                  builder: (context, state) {
                    return CheckBoxWidget(
                      isChecked: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocListener<LoginBloc, CommonState>(
                  bloc: loginBloc,
                  listener: (context, state) {
                    if (state is LoadingState) {
                      showLoadingDialog(context);
                    }
                    if (state is SuccessState) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      if (state.data == false) {
                        context.go('/settings');
                      } else {
                        context.go('/home');
                      }
                    }
                    if (state is FailureState) {
                      context.pop();
                      showErrorDialog(context, message: state.message);
                    }
                  },
                  child: PrimaryButton(
                    buttonName: "Entrar",
                    functionPrimaryButton: () {
                      loginBloc.add(
                        RealizeLogin(
                          username: controllerLogin.text,
                          password: controllerPassword.text,
                          saveCredentials: isChecked,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
