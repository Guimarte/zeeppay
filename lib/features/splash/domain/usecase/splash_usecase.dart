import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_devices_repository.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_ercards_repository.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_store_repository.dart';
import 'package:zeeppay/features/splash/domain/repository/splash_theme_repository.dart';
import 'package:zeeppay/shared/models/device_pos_model.dart';
import 'package:zeeppay/shared/models/ercards_pos.dart';
import 'package:zeeppay/shared/models/settings_pos_model.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';
import 'package:zeeppay/shared/models/theme_pos_model.dart';

class SplashUsecase {
  final SplashStoreRepository _loginStoreRepository;
  final SplashERCardsRepository _networkRepository;
  final SplashThemeRepository _splashThemeRepository;
  final SplashDevicesRepository _devicesRepository;

  SplashUsecase(
    this._loginStoreRepository,
    this._networkRepository,
    this._splashThemeRepository,
    this._devicesRepository,
  );

  Future<void> startSplash() async {
    List<StorePosModel> storePosModel = await _loginStoreRepository.call();
    ERCardsModel erCardsModel = await _networkRepository.call();
    ThemePosModel themePosModel = await _splashThemeRepository.call();
    List<DeviceModel> devicesModel = await _devicesRepository.call();

    SettingsPosDataStore().posData = SettingsPosModel(
      erCardsModel: erCardsModel,
      themePos: themePosModel,
      store: storePosModel,
      devices: devicesModel,
    );
  }
}
