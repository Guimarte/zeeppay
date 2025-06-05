class LancamentoFaturaModel {
  final double valor;
  final String historico;
  final String descricaoExtrato;
  final String complemento;
  final DateTime dataLancamento;
  final String plastico;
  final String nomePortador;

  LancamentoFaturaModel({
    required this.valor,
    required this.historico,
    required this.descricaoExtrato,
    required this.complemento,
    required this.dataLancamento,
    required this.plastico,
    required this.nomePortador,
  });

  factory LancamentoFaturaModel.fromJson(Map<String, dynamic> json) {
    return LancamentoFaturaModel(
      valor: (json['dblValor'] ?? 0).toDouble(),
      historico: json['strHistorico'] ?? '',
      descricaoExtrato: json['strDescricaoExtrato'] ?? '',
      complemento: json['strComplemento'] ?? '',
      dataLancamento: DateTime.parse(json['datDataLancamento']),
      plastico: json['strPlastico'] ?? '',
      nomePortador: json['strNomePortador'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'dblValor': valor,
    'strHistorico': historico,
    'strDescricaoExtrato': descricaoExtrato,
    'strComplemento': complemento,
    'datDataLancamento': dataLancamento.toIso8601String(),
    'strPlastico': plastico,
    'strNomePortador': nomePortador,
  };

  static List<LancamentoFaturaModel> fromJsonList(List jsonList) =>
      jsonList.map((e) => LancamentoFaturaModel.fromJson(e)).toList();
}
