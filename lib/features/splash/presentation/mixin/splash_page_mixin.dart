import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/core/default_options.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_events.dart';
import 'package:zeeppay/features/splash/presentation/page/splash_page.dart';

mixin SplashPageMixin<T extends StatefulWidget> on State<SplashPage> {
  final splashBloc = getIt.get<SplashBloc>();

  @override
  void initState() {
    super.initState();
    _checkTokenAndProceed();
  }

  void _checkTokenAndProceed() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        if (!DefaultOptions.hasBaseToken) {
          context.go('/token-setup');
        } else {
          splashBloc.add(SplashEventStart());
        }
      }
    });
  }
}
