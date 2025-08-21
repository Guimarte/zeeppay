class UrlsInvoice {
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
}
