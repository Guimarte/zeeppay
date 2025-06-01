import 'package:dio/dio.dart';
import 'package:zeeppay/core/default_options.dart';
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
    final token = DefaultOptions.baseTokenStore;
    final response = await zeeppayDio.get(
      url: UrlsLogin.loginTenant,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response?.data == null || response?.statusCode != 200) {
      throw Exception('Failed to login');
    }
    ZeeppayDio.authInterceptor.setToken(response!.data['access_token']);

    final requestStore = await zeeppayDio.get(url: UrlsLogin.settingsPos);

    if (requestStore!.statusCode == 200) {
      PosDataStore().posData = PosDataModel.fromJson(requestStore.data['data']);
      return PosDataModel.fromJson(requestStore.data['data']);
    } else {
      throw Exception('Failed to load settings');
    }
  }
}
