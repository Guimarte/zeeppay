import 'package:zeeppay/flavors/flavor_config.dart';

class UrlsInvoice {
  static FlavorConfig get _flavorConfig => FlavorConfig.instance;

  static String consultarUltimasFaturas(String urlBase) {
    return '$urlBase/Fatura/ConsultarUltimasFaturas';
  }

  static String getConsultarPerfil(String urlBase, String cpf) {
    return '$urlBase/Cliente/ConsultarPerfil?strCliente=$cpf';
  }

  static String getPaymentInvoice(
    String urlBase,
    String deviceId,
    String cashierSessionId,
  ) {
    return '$urlBase/point-of-sales/devices/$deviceId/cashier/$cashierSessionId/register-payment';
  }

  static String openCash(String urlBase, String deviceId) {
    return '$urlBase/point-of-sales/devices/$deviceId/cashier/open';
  }
}
