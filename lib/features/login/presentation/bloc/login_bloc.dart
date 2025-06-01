import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/login/domain/usecase/login_usecase.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_event.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';

class LoginBloc extends Bloc<LoginEvent, CommonState> {
  LoginBloc({required this.loginUsecase}) : super(InitialState()) {
    on<RealizeLogin>(_realizeLogin);
  }

  LoginUsecase loginUsecase;

  _realizeLogin(RealizeLogin event, Emitter<CommonState> emitter) async {
    emitter(LoadingState());
    await loginUsecase.login();
    await Future.delayed(Duration(seconds: 5));
    emitter(SuccessState('Logado'));
  }
}
