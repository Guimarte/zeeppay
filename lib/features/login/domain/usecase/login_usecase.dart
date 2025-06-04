import 'package:zeeppay/features/login/domain/repository/login_repository.dart';

abstract class LoginUsecase {
  Future<String> call(String username, String password);
}

class LoginUsecaseImpl implements LoginUsecase {
  final LoginRepository _loginRepository;

  LoginUsecaseImpl(this._loginRepository);

  @override
  Future<String> call(String username, String password) async {
    return await _loginRepository(username, password);
  }
}
