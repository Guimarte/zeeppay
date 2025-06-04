import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/external/urls.dart';

abstract class LoginRepository {
  Future<String> call(String username, String password);
}

class LoginRepositoryImpl implements LoginRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  PosDataStore get posData => PosDataStore();

  @override
  Future<String> call(String username, String password) async {
    final requestStore = await zeeppayDio.post(
      url: UrlsDefault.urlLogin(posData.posData!.settings.netWork.endpoint),
      isLoginRequest: true,
      data: {
        'username': username,
        'password': password,
        'grant_type': 'password',
      },
    );
    return requestStore.data['access_token'] as String;
  }
}
