class SellModel {
  //CAMPO SENHA DEVE SER ENVIADO CRIPTOGTAFADO COM A SENHA + CHAVE HEX
  String? senha;

  String? tipoCriptografia = "3DES";

  //NUMERACAO DO PLASTICO SERA RETORNADA NO ENDPOINT /Cliente/ConsultarPerfil, VARIAVEL: strPlasticoTitular, NO QUAL ESTARÁ DENTRO DE lstPlasticos ou será coletada direto pela leitora
  String? plastico;

  // (1 - COMPRA A VISTA, 2 - PARCELADO SEM JUROS, 3 - COMPRA COM JUROS)
  String? tipoParcelamento;

  String? tipoOperacao = "C";

  //VALOR DA VENDA
  double? valorCompra;

  //CALCULA PRESTAÇÃO DEVE SER ENVIADO COMO TRUE, CASO CONTRARIO NÃO SERÁ POSSIVEL REALIZAR A VENDA
  bool? calculaPrestacao = true;

  //ENVIAR NSU DA COMPRA
  String? nsuCaptura;

  //ENVIAR 0 + CNPJ
  String? codigoEstabelecimento;

  //PODE SER ENVIADO QUALQUER NUMERAÇÃO
  String? terminal;

  //DATA DA COMPRA NO FORMATO: AAAA-MM-DD
  String? dataCompra;

  //DATA DA COMPRA E HORARIO NO FORMATO: AAAA-MM-DDTHH:MM:SS.916Z
  String? dataLocal;

  //PRAZO SE REFERE A QUANTIDADE DE PARCELAS QUE A COMPRA POSSUI, 1: A VISTA, 2: 2X E ASSIM CONSEQUENTEMENTE
  int? prazo;

  //EM CASO DA COMPRA SER A VISTA, PLANO NÃO DEVERÁ SER INFORMADO, MAS CASO FOR PARCELADA COM JUROS ENVIAR PLANO "1"
  String? plano;

  String? produto = "";

  String? cartao = "";

  String? cpf = "";

  String? usuario;

  SellModel({
    this.senha,
    String? tipoCriptografia,
    this.plastico,
    this.tipoParcelamento,
    String? tipoOperacao,
    this.valorCompra,
    bool? calculaPrestacao,
    this.nsuCaptura,
    this.codigoEstabelecimento,
    this.terminal,
    this.dataCompra,
    this.dataLocal,
    this.prazo,
    this.plano,
    String? produto,
    String? cartao,
    String? cpf,
    this.usuario,
  })  : tipoCriptografia = tipoCriptografia ?? "3DES",
        tipoOperacao = tipoOperacao ?? "C",
        calculaPrestacao = calculaPrestacao ?? true,
        produto = produto ?? "",
        cartao = cartao ?? "",
        cpf = cpf ?? "";

  Map<String, dynamic> toJson() {
    return {
      "strSenha": senha,
      "strTipoCriptografia": tipoCriptografia,
      "strPlastico": plastico,
      "intTipoParcelamento": tipoParcelamento,
      "strTipoOperacao": tipoOperacao,
      "dblValorCompra": (valorCompra ?? 0.0).toStringAsFixed(2),
      "blnCalculaPrestacao": calculaPrestacao,
      "strNsuCaptura": nsuCaptura,
      "strCodigoEstabelecimento": codigoEstabelecimento,
      "strTerminal": terminal,
      "datDataCompra": dataCompra,
      "datDataLocal": dataLocal,
      "intPrazo": prazo,
      "strPlano": plano,
      "strProduto": produto,
      "lngCartao": cartao,
      "strCpf": cpf,
      "strUsuario": usuario,
    };
  }

  factory SellModel.empty() {
    return SellModel(
      senha: null,
      tipoCriptografia: "3DES",
      plastico: null,
      tipoParcelamento: null,
      tipoOperacao: "C",
      valorCompra: 0.0,
      calculaPrestacao: true,
      nsuCaptura: null,
      codigoEstabelecimento: null,
      terminal: null,
      dataCompra: null,
      dataLocal: null,
      prazo: null,
      plano: null,
      produto: "",
      cartao: "",
      cpf: "",
      usuario: null,
    );
  }
}
