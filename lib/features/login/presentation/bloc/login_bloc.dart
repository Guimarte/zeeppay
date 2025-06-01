import 'package:bloc/bloc.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_event.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';
import 'package:zeeppay/shared/database/database.dart';

class LoginBloc extends Bloc<LoginEvent, CommonState> {
  LoginBloc() : super(InitialState()) {
    on<RealizeLogin>(_realizeLogin);
  }

  // LoginUsecase loginUsecase;

  _realizeLogin(RealizeLogin event, Emitter<CommonState> emitter) async {
    emitter(LoadingState());
    // await loginUsecase.login();

    final database = getIt<Database>();

    if (database.getString("store") != null) {
      emitter(SuccessState('Logado'));
      return;
    }
    await Future.delayed(Duration(seconds: 5));
    emitter(SuccessState('configura'));
  }
}
