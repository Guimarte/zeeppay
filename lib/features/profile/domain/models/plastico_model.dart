class PlasticoModel {
  final String nomePortador;
  final String cpfPortador;
  final String numero;
  final DateTime validade;
  final DateTime dataInclusao;
  final String situacao;
  final DateTime dataSituacao;
  final String titularidade;
  final String bandeira;
  final String descricaoBandeira;
  final String temSenha;
  final String cvv;

  PlasticoModel({
    required this.nomePortador,
    required this.cpfPortador,
    required this.numero,
    required this.validade,
    required this.dataInclusao,
    required this.situacao,
    required this.dataSituacao,
    required this.titularidade,
    required this.bandeira,
    required this.descricaoBandeira,
    required this.temSenha,
    required this.cvv,
  });

  factory PlasticoModel.fromJson(Map<String, dynamic> json) {
    return PlasticoModel(
      nomePortador: json['strNomePortador'],
      cpfPortador: json['strCpfPortador'],
      numero: json['strPlastico'],
      validade: DateTime.parse(json['datValidade']),
      dataInclusao: DateTime.parse(json['datDataInclusao']),
      situacao: json['strSituacao'],
      dataSituacao: DateTime.parse(json['datDataSituacao']),
      titularidade: json['strTitularidade'],
      bandeira: json['strBandeira'],
      descricaoBandeira: json['strDescricaoBandeira'],
      temSenha: json['strTemSenha'],
      cvv: json['strCvv'],
    );
  }

  static List<PlasticoModel> fromJsonList(List json) =>
      json.map((e) => PlasticoModel.fromJson(e)).toList();
}
