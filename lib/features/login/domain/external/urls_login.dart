import 'package:zeeppay/flavors/flavor_config.dart';

class UrlsLogin {
  FlavorConfig get flavorConfig => FlavorConfig.instance;
  String get urlDefault =>
      'https://${flavorConfig.subdomain}.zeeppay.com.br/api';
  String get loginTenant => '$urlDefault/auth/api-keys/access-token';
  String get settingsPos => '$urlDefault/settings/pos-settings';
}
