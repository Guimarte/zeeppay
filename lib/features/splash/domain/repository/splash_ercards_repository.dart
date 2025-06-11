import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/ercards_pos.dart';

abstract class SplashERCardsRepository {
  Future<ERCardsModel> call();
}

class SplashERCardsRepositoryImpl implements SplashERCardsRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  @override
  Future<ERCardsModel> call() async {
    final requestERCards = await zeeppayDio.get(
      url: UrlsLogin.ercards,
      isStoreRequest: false,
    );

    if (requestERCards.statusCode == 200) {
      return ERCardsModel.fromJson(requestERCards.data['data']['value']);
    } else {
      throw Exception('Failed to load store');
    }
  }
}
