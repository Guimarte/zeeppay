import 'package:zeeppay/features/profile/domain/models/lancamento_fatura_model.dart';

class FaturaModel {
  final int numeroFatura;
  final double valor;
  final double valorPago;
  final DateTime dataVencimento;
  final String situacao;
  final String descricaoSituacao;
  final double valorMinimo;
  final double saldoAnterior;
  final double saldoDevedor;
  final double encargos;
  final List<LancamentoFaturaModel> lancamentos;

  FaturaModel({
    required this.numeroFatura,
    required this.valor,
    required this.valorPago,
    required this.dataVencimento,
    required this.situacao,
    required this.descricaoSituacao,
    required this.valorMinimo,
    required this.saldoAnterior,
    required this.saldoDevedor,
    required this.encargos,
    required this.lancamentos,
  });

  factory FaturaModel.fromJson(Map<String, dynamic> json) {
    return FaturaModel(
      numeroFatura: json['lngFatura'],
      valor: (json['dblValor'] ?? 0).toDouble(),
      valorPago: (json['dblValorPago'] ?? 0).toDouble(),
      dataVencimento: DateTime.parse(json['datDataVencimento']),
      situacao: json['strSituacao'],
      descricaoSituacao: json['strDescrSituacao'],
      valorMinimo: (json['dblValorMinimo'] ?? 0).toDouble(),
      saldoAnterior: (json['dblSaldoAnterior'] ?? 0).toDouble(),
      saldoDevedor: (json['dblSaldoDevedor'] ?? 0).toDouble(),
      encargos: (json['dblEncargos'] ?? 0).toDouble(),
      lancamentos: LancamentoFaturaModel.fromJsonList(json['lstLancamentos']),
    );
  }

  Map<String, dynamic> toJson() => {
    'lngFatura': numeroFatura,
    'dblValor': valor,
    'dblValorPago': valorPago,
    'datDataVencimento': dataVencimento.toIso8601String(),
    'strSituacao': situacao,
    'strDescrSituacao': descricaoSituacao,
    'dblValorMinimo': valorMinimo,
    'dblSaldoAnterior': saldoAnterior,
    'dblSaldoDevedor': saldoDevedor,
    'dblEncargos': encargos,
    'lstLancamentos': lancamentos.map((e) => e.toJson()).toList(),
  };
}
