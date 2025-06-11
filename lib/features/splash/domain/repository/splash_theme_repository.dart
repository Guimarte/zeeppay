import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/theme_pos_model.dart';

abstract class SplashThemeRepository {
  Future<ThemePosModel> call();
}

class SplashThemeRepositoryImpl implements SplashThemeRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  @override
  Future<ThemePosModel> call() async {
    final requestTheme = await zeeppayDio.get(
      url: UrlsLogin.theme,
      isStoreRequest: false,
    );

    if (requestTheme.statusCode == 200) {
      return ThemePosModel.fromJson(requestTheme.data['data']['value']);
    } else {
      throw Exception('Failed to load store');
    }
  }
}
