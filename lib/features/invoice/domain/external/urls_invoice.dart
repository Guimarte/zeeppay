import 'package:zeeppay/flavors/flavor_config.dart';

class UrlsInvoice {
  static FlavorConfig get _flavorConfig => FlavorConfig.instance;

  static String consultarUltimasFaturas(String urlBase) {
    return '$urlBase/Fatura/ConsultarUltimasFaturas';
  }

  static String getConsultarPerfil(String urlBase, String cpf) {
    return '$urlBase/Cliente/ConsultarPerfil?strCliente=$cpf';
  }

  static String get urlDefault =>
      'https://${_flavorConfig.subdomain}.zeeppay.com.br/api';

  static String getPaymentInvoice(String deviceId, String cashierSessionId) {
    return '$urlDefault/point-of-sales/devices/$deviceId/cashier/$cashierSessionId/register-payment';
  }

  static String openCash(String urlBase, String deviceId) {
    return '$urlBase/point-of-sales/devices/$deviceId/cashier/open';
  }
}
