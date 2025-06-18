import 'package:bloc/bloc.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/login/domain/usecase/login_usecase.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_event.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';
import 'package:zeeppay/shared/database/database.dart';

class LoginBloc extends Bloc<LoginEvent, CommonState> {
  LoginBloc({required this.loginUsecase}) : super(InitialState()) {
    on<RealizeLogin>(_realizeLogin);
  }

  final LoginUsecase loginUsecase;

  _realizeLogin(RealizeLogin event, Emitter<CommonState> emitter) async {
    emitter(LoadingState());
    await loginUsecase.call(event.username, event.password);
    final database = getIt<Database>();
    if (event.saveCredentials) {
      database.setString("user", event.username);
      database.setString("password", event.password);
      database.setBool("saveCredentials", event.saveCredentials);
    }

    if (database.getString("store") != null) {
      database.setString("userToken", event.username);
      database.setString("passwordToken", event.password);
      emitter(SuccessState(true));
      return;
    }
    emitter(SuccessState(false));
    return;
  }
}
