import 'package:zeeppay/features/profile/domain/models/fatura_model.dart';
import 'package:zeeppay/features/profile/domain/models/plastico_model.dart';
import 'package:zeeppay/features/profile/domain/models/vencimento_futuro_model.dart';

class ClienteModel {
  final String cpf;
  final String nome;
  final String situacao;
  final String motivoSituacao;
  final String produto;
  final String produtoDescricao;
  final int numeroCartao;
  final DateTime validade;
  final DateTime dataInclusao;
  final double limite;
  final double limiteDisponivelCompras;
  final double limiteUtilizadoCompras;
  final double limiteUtilizadoPercentual;
  final int score;
  final int quantidadeCompras;
  final String email;
  final int diaCartao;
  final int diaCorte;
  final DateTime dataUltimaFatura;
  final DateTime dataProximaFatura;
  final DateTime dataFaturaAnterior;
  final String nomeReduzido;
  final String faturaPorEmail;
  final String tipoLimite;
  final String formaPagamento;
  final DateTime dataNascimento;
  final double renda;
  final String ddd1;
  final String telefone1;
  final List<PlasticoModel> plasticos;
  final List<VencimentoFuturoModel> vencimentosFuturos;
  final FaturaModel ultimaFatura;

  ClienteModel({
    required this.cpf,
    required this.nome,
    required this.situacao,
    required this.motivoSituacao,
    required this.produto,
    required this.produtoDescricao,
    required this.numeroCartao,
    required this.validade,
    required this.dataInclusao,
    required this.limite,
    required this.limiteDisponivelCompras,
    required this.limiteUtilizadoCompras,
    required this.limiteUtilizadoPercentual,
    required this.score,
    required this.quantidadeCompras,
    required this.email,
    required this.diaCartao,
    required this.diaCorte,
    required this.dataUltimaFatura,
    required this.dataProximaFatura,
    required this.dataFaturaAnterior,
    required this.nomeReduzido,
    required this.faturaPorEmail,
    required this.tipoLimite,
    required this.formaPagamento,
    required this.dataNascimento,
    required this.renda,
    required this.ddd1,
    required this.telefone1,
    required this.plasticos,
    required this.vencimentosFuturos,
    required this.ultimaFatura,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      cpf: json['strCliente'],
      nome: json['strNome'],
      situacao: json['strSituacao'],
      motivoSituacao: json['strMotivoSituacao'],
      produto: json['strProduto'],
      produtoDescricao: json['strProdutoDescricao'],
      numeroCartao: json['lngCartao'],
      validade: DateTime.parse(json['datDataValidade']),
      dataInclusao: DateTime.parse(json['datDataInclusao']),
      limite: (json['dblLimite'] ?? 0).toDouble(),
      limiteDisponivelCompras: (json['dblLimiteDisponivelCompras'] ?? 0)
          .toDouble(),
      limiteUtilizadoCompras: (json['dblLimiteUtilizadoCompras'] ?? 0)
          .toDouble(),
      limiteUtilizadoPercentual: (json['dblLimiteUtilizadoPercentual'] ?? 0)
          .toDouble(),
      score: json['intScore'],
      quantidadeCompras: json['lngQuantidadeCompras'],
      email: json['strEmail'],
      diaCartao: json['intDiaCartao'],
      diaCorte: json['intDiaCorte'],
      dataUltimaFatura: DateTime.parse(json['strDataUltimaFatura']),
      dataProximaFatura: DateTime.parse(json['strDataProximaFatura']),
      dataFaturaAnterior: DateTime.parse(json['strDataFaturaAnterior']),
      nomeReduzido: json['strNomeReduzido'],
      faturaPorEmail: json['strFaturaPorEmail'],
      tipoLimite: json['strTipoLimite'],
      formaPagamento: json['strFormaPagamento'],
      dataNascimento: DateTime.parse(json['datDataNascimento']),
      renda: (json['dblRenda'] ?? 0).toDouble(),
      ddd1: json['strDDD1'],
      telefone1: json['strFone1'],
      plasticos: PlasticoModel.fromJsonList(json['lstPlasticos']),
      vencimentosFuturos: VencimentoFuturoModel.fromJsonList(
        json['lstVencimentosFuturos'],
      ),
      ultimaFatura: FaturaModel.fromJson(json['objUltimaFatura']),
    );
  }

  static List<ClienteModel> fromJsonList(List json) =>
      json.map((e) => ClienteModel.fromJson(e)).toList();
}
