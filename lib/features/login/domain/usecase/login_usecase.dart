import 'package:dartz/dartz.dart';
import 'package:zeeppay/features/login/domain/repository/login_repository.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class LoginUsecase {
  Future<Either<Failure, String>> call(String username, String password);
}

class LoginUsecaseImpl implements LoginUsecase {
  final LoginRepository _loginRepository;

  LoginUsecaseImpl(this._loginRepository);

  @override
  Future<Either<Failure, String>> call(String username, String password) async {
    return await _loginRepository.call(username, password);
  }
}
