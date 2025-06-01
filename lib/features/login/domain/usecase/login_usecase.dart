import 'package:zeeppay/features/login/domain/models/pos_settings.dart';
import 'package:zeeppay/features/login/domain/repository/login_settings_store_repository.dart';

class LoginUsecase {
  final LoginSettingsStoreRepository _loginStoreRepository;

  LoginUsecase(this._loginStoreRepository);

  Future<PosDataModel> login() async {
    return await _loginStoreRepository.call();
  }
}
