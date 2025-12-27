import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_events.dart';
import 'package:zeeppay/features/splash/presentation/mixin/splash_page_mixin.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SplashPageMixin<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, CommonState>(
      bloc: splashBloc,
      listener: (context, state) {
        if (state is SuccessState) {
          context.push('/login');
        } else if (state is FailureState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Erro de Conexão'),
              content: SingleChildScrollView(child: Text(state.message)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    splashBloc.add(SplashEventStart());
                  },
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Image.asset('assets/default/splash.png', width: 150),
          ),
        );
      },
    );
  }
}
