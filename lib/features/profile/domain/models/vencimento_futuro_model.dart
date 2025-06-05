class VencimentoFuturoModel {
  final String tipoOperacao;
  final int autorizacao;
  final double valorParcela;
  final int parcela;
  final DateTime vencimento;
  final double valorPago;
  final double saldoDevedor;
  final int prazo;
  final DateTime dataCompra;
  final String loja;
  final String nomePortador;
  final String plastico;
  final String formaPagamento;
  final double valorDesconto;
  final double valorPresente;

  VencimentoFuturoModel({
    required this.tipoOperacao,
    required this.autorizacao,
    required this.valorParcela,
    required this.parcela,
    required this.vencimento,
    required this.valorPago,
    required this.saldoDevedor,
    required this.prazo,
    required this.dataCompra,
    required this.loja,
    required this.nomePortador,
    required this.plastico,
    required this.formaPagamento,
    required this.valorDesconto,
    required this.valorPresente,
  });

  factory VencimentoFuturoModel.fromJson(Map<String, dynamic> json) {
    return VencimentoFuturoModel(
      tipoOperacao: json['strTipoOperacao'],
      autorizacao: json['lngAutorizacao'],
      valorParcela: (json['dblValorParcela'] ?? 0).toDouble(),
      parcela: json['intParcela'],
      vencimento: DateTime.parse(json['datVencimento']),
      valorPago: (json['dblValorPago'] ?? 0).toDouble(),
      saldoDevedor: (json['dblSaldoDevedor'] ?? 0).toDouble(),
      prazo: json['intPrazo'],
      dataCompra: DateTime.parse(json['datCompra']),
      loja: json['strDescrLoja'],
      nomePortador: json['strNomePortador'],
      plastico: json['strPlastico'],
      formaPagamento: json['strFormaPagamento'],
      valorDesconto: (json['dblValorDesconto'] ?? 0).toDouble(),
      valorPresente: (json['dblValorPresente'] ?? 0).toDouble(),
    );
  }

  static List<VencimentoFuturoModel> fromJsonList(List json) =>
      json.map((e) => VencimentoFuturoModel.fromJson(e)).toList();
}
