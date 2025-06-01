import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/splash/domain/usecase/splash_usecase.dart';
import 'package:zeeppay/features/splash/presentation/bloc/splash_events.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';

class SplashBloc extends Bloc<SplashEvent, CommonState> {
  SplashBloc({required this.splashUsecase}) : super(InitialState()) {
    on<SplashEventStart>(_start);
  }

  SplashUsecase splashUsecase;

  _start(SplashEventStart event, Emitter<CommonState> emitter) async {
    await splashUsecase.startSplash();
    emitter(SuccessState('Splash concluída'));
  }
}
