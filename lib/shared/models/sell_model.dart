class SellModel {
  //CAMPO SENHA DEVE SER ENVIADO CRIPTOGTAFADO COM A SENHA + CHAVE HEX
  final String senha;

  final String tipoCriptografia = "3des";

  //NUMERACAO DO PLASTICO SERA RETORNADA NO ENDPOINT /Cliente/ConsultarPerfil, VARIAVEL: strPlasticoTitular, NO QUAL ESTARÁ DENTRO DE lstPlasticos ou será coletada direto pela leitora
  final String plastico;

  // (1 - COMPRA A VISTA, 2 - PARCELADO SEM JUROS, 3 - COMPRA COM JUROS)
  final String tipoParcelamento;

  final String tipoOperacao = "C";

  //VALOR DA VENDA
  final double valorCompra;

  final bool calculaPrestacao = true;

  //ENVIAR NSU DA COMPRA
  final String nsuCaptura;

  //ENVIAR 0 + CNPJ
  final String codigoEstabelecimento;

  //PODE SER ENVIADO QUALQUER NUMERAÇÃO
  final String terminal;

  //DATA DA COMPRA NO FORMATO: AAAA-MM-DD
  final String dataCompra;

  //DATA DA COMPRA E HORARIO NO FORMATO: AAAA-MM-DDTHH:MM:SS.916Z
  final String dataLocal;

  //PRAZO SE REFERE A QUANTIDADE DE PARCELAS QUE A COMPRA POSSUI, 1: A VISTA, 2: 2X E ASSIM CONSEQUENTEMENTE
  final String prazo;

  //EM CASO DA COMPRA SER A VISTA, PLANO NÃO DEVERÁ SER INFORMADO, MAS CASO FOR PARCELADA COM JUROS ENVIAR PLANO "1"
  final String plano;

  final String produto = "";

  final String cartao = "";

  final String cpf = "";

  final String usuario;

  SellModel copyWith({
    String? senha,
    String? plastico,
    String? tipoParcelamento,
    double? valorCompra,
    String? nsuCaptura,
    String? codigoEstabelecimento,
    String? terminal,
    String? dataCompra,
    String? dataLocal,
    String? prazo,
    String? plano,
    String? usuario,
  }) {
    return SellModel(
      senha: senha ?? this.senha,
      plastico: plastico ?? this.plastico,
      tipoParcelamento: tipoParcelamento ?? this.tipoParcelamento,
      valorCompra: valorCompra ?? this.valorCompra,
      nsuCaptura: nsuCaptura ?? this.nsuCaptura,
      codigoEstabelecimento:
          codigoEstabelecimento ?? this.codigoEstabelecimento,
      terminal: terminal ?? this.terminal,
      dataCompra: dataCompra ?? this.dataCompra,
      dataLocal: dataLocal ?? this.dataLocal,
      prazo: prazo ?? this.prazo,
      plano: plano ?? this.plano,
      usuario: usuario ?? this.usuario,
    );
  }

  SellModel({
    required this.senha,
    required this.plastico,
    required this.tipoParcelamento,
    required this.valorCompra,
    required this.nsuCaptura,
    required this.codigoEstabelecimento,
    required this.terminal,
    required this.dataCompra,
    required this.dataLocal,
    required this.prazo,
    required this.plano,
    required this.usuario,
  });

  Map<String, dynamic> toJson() {
    return {
      "strSenha": senha,
      "strTipoCriptografia": tipoCriptografia,
      "strPlastico": plastico,
      "intTipoParcelamento": tipoParcelamento,
      "strTipoOperacao": tipoOperacao,
      "dblValorCompra": valorCompra.toStringAsFixed(2),
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
}
