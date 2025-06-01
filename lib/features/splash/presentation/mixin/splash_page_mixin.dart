import 'package:flutter/widgets.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_events.dart';
import 'package:zeeppay/features/splash/presentation/page/splash_page.dart';

mixin SplashPageMixin<T extends StatefulWidget> on State<SplashPage> {
  final splashBloc = getIt.get<SplashBloc>();

  @override
  void initState() {
    super.initState();

    splashBloc.add(SplashEventStart());
  }
}
