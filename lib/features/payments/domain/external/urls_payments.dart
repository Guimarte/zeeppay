class UrlsPayments {
  static String insertPayments(String urlBase) {
    return '$urlBase/Autorizador/RegistrarOperacaoV2';
  }

  static String getReceive(String urlBase, String nsu) {
    return '$urlBase/Autorizador/EmitirComprovanteTransacaoApp?lngAutorizacao=$nsu';
  }
}
