class UrlsPayments {
  static String insertPayments(String urlBase) {
    return '$urlBase/webapi/Autorizador/RegistrarOperacaoV2';
  }

  static String getReceive(String urlBase, String nsu) {
    return '$urlBase/webapi/Autorizador/EmitirComprovanteTransacaoApp?lngAutorizacao=$nsu';
  }
}
