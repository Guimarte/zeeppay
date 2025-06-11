import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';

abstract class SplashStoreRepository {
  Future<List<StorePosModel>> call();
}

class SplashStoreRepositoryImpl implements SplashStoreRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  @override
  Future<List<StorePosModel>> call() async {
    final requestStore = await zeeppayDio.get(
      url: UrlsLogin.store,
      isStoreRequest: true,
    );

    if (requestStore.statusCode == 200) {
      return StorePosModel.fromJsonList(requestStore.data['data']);
    } else {
      throw Exception('Failed to load store');
    }
  }
}
