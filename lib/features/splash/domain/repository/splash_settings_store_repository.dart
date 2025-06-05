import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/pos_settings.dart';

abstract class SplashSettingsStoreRepository {
  Future<PosDataModel> call();
}

class SplashSettingsStoreRepositoryImpl
    implements SplashSettingsStoreRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  @override
  Future<PosDataModel> call() async {
    final requestStore = await zeeppayDio.get(
      url: UrlsLogin.settingsPos,
      isStoreRequest: true,
    );

    if (requestStore.statusCode == 200) {
      PosDataStore().posData = PosDataModel.fromJson(requestStore.data['data']);
      return PosDataModel.fromJson(requestStore.data['data']);
    } else {
      throw Exception('Failed to load settings');
    }
  }
}
