import 'package:zeeppay/features/splash/domain/repository/splash_settings_store_repository.dart';
import 'package:zeeppay/shared/models/pos_settings.dart';

class SplashUsecase {
  final SplashSettingsStoreRepository _loginStoreRepository;

  SplashUsecase(this._loginStoreRepository);

  Future<PosDataModel> startSplash() async {
    return await _loginStoreRepository.call();
  }
}
