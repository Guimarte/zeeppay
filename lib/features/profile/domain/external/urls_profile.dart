class UrlsProfile {
  static String getConsultarPerfil(String cpf) {
    return '/webapi/Cliente/ConsultarPerfil?strCliente=$cpf';
  }
}
