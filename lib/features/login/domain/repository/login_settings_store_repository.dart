import 'package:dio/dio.dart';
import 'package:zeeppay/core/default_options.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/login/domain/external/urls_login.dart';
import 'package:zeeppay/features/login/domain/models/pos_settings.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

abstract class LoginSettingsStoreRepository {
  Future<PosDataModel> call();
}

class LoginSettingsRepositoryImpl implements LoginSettingsStoreRepository {
  ZeeppayDio dioImplementation = ZeeppayDio();
  @override
  Future<PosDataModel> call() async {
    final token = DefaultOptions.baseTokenStore;
    final response = await dioImplementation.get(
      url: UrlsLogin().loginTenant,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response?.data == null || response?.statusCode != 200) {
      throw Exception('Failed to login');
    }
    ZeeppayDio.authInterceptor.setToken(response!.data['access_token']);

    final requestStore = await dioImplementation.get(
      url: UrlsLogin().settingsPos,
    );

    if (requestStore!.statusCode == 200) {
      PosDataStore().posData = PosDataModel.fromJson(requestStore.data['data']);
      return PosDataModel.fromJson(requestStore.data['data']);
    } else {
      throw Exception('Failed to load settings');
    }
  }
}
