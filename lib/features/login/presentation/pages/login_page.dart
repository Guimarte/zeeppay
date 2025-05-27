import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_event/login_event.dart';
import 'package:zeeppay/features/login/presentation/mixin/login_page_mixin.dart';
import 'package:zeeppay/features/login/presentation/widgets/text_input_custom_login.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';
import 'package:zeeppay/shared/widgets/primary_button.dart';
import 'package:zeeppay/theme/sizes_app.dart';

class LoginPage extends StatelessWidget with LoginPageMixin {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.4,

                  child: Column(
                    spacing: SizesApp.space12,
                    children: [
                      TextInputCustomLogin(
                        suffixIcon: null,
                        controller: controllerLogin,
                        isPassword: false,
                        hintText: hintTextLogin,
                        textInputType: inputTypeLogin,
                        iconFunction: () {},
                      ),
                      TextInputCustomLogin(
                        suffixIcon: null,
                        controller: controllerPassword,
                        isPassword: true,
                        hintText: hintTextPassword,
                        textInputType: inputTypePassword,
                        iconFunction: () {},
                      ),
                      BlocListener<LoginBloc, CommonState>(
                        listener: (context, state) {
                          if (state is LoadingState) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                          }
                          if (state is SuccessState) {
                            context.go('/settings');
                          }
                        },
                        child: PrimaryButton(
                          buttonName: "Login",
                          functionPrimaryButton: () {
                            context.read<LoginBloc>().add(
                              RealizeLogin(
                                login: controllerLogin.text,
                                password: controllerPassword.text,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
