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
    final result = await loginUsecase.call(event.username, event.password);
    result.fold(
      (failure) {
        emitter(FailureState(failure.message!));
      },
      (token) {
        saveCredentials(event.username, event.password, event.saveCredentials);
        return emitter(SuccessState(true));
      },
    );
  }

  void saveCredentials(String username, String password, bool savePassword) {
    final database = getIt<Database>();
    database.setString("userToken", username);
    database.setString("passwordToken", password);
    if (savePassword) {
      database.setString("user", username);
      database.setString("password", password);
      database.setBool("saveCredentials", savePassword);
    }
  }
}
