import 'package:zeeppay/flavors/flavor_config.dart';

class UrlsLogin {
  static FlavorConfig get _flavorConfig => FlavorConfig.instance;
  static String get urlDefault =>
      'https://${_flavorConfig.subdomain}.zeeppay.com.br/api';
  static String get loginTenant => '$urlDefault/auth/api-keys/access-token';
  static String get ercards => '$urlDefault/settings/ercards';
  static String get theme => '$urlDefault/settings/theme';
  static String get store => '$urlDefault/stores';
  static String get devices => '$urlDefault/point-of-sales/devices';
}
