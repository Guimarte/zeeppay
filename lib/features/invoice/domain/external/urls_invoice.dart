class UrlsInvoice {
  static String consultarUltimasFaturas(String urlBase) {
    return '$urlBase/Fatura/ConsultarUltimasFaturas';
  }

  static String getConsultarPerfil(String urlBase, String cpf) {
    return '$urlBase/Cliente/ConsultarPerfil?strCliente=$cpf';
  }
}
