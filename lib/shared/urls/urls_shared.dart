import 'package:zeeppay/flavors/flavor_config.dart';

class UrlsShared {
  static FlavorConfig get _flavorConfig => FlavorConfig.instance;

  static String get urlDefault =>
      'https://${_flavorConfig.subdomain}.zeeppay.com.br/api';

  static String openCash(String deviceId) {
    return '$urlDefault/point-of-sales/devices/$deviceId/cashier-sessions/open';
  }

  static String closeCashier(String deviceId, String cashierSessionId) {
    return '$urlDefault/point-of-sales/devices/$deviceId/cashier/$cashierSessionId/close';
  }

  static String currentSession(String deviceId) {
    return '$urlDefault/point-of-sales/devices/$deviceId/cashier-sessions/current';
  }
}
