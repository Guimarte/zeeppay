class ReceiveModel {
  final String terminal;
  final String lojista;
  final String cnpj;
  final String fone;
  final String endereco;
  final String nsuTerminal;
  final int nsuProcessadora;
  final String data;
  final String hora;
  final String cliente;
  final String cartao;
  final String valor;
  final int autorizacao;
  final int prazo;
  final String tipoOperacao;
  final String foneCliente;
  final int tipoParcelamento;
  final String cetAno;
  final String prestacao;

  ReceiveModel({
    required this.terminal,
    required this.lojista,
    required this.cnpj,
    required this.fone,
    required this.endereco,
    required this.nsuTerminal,
    required this.nsuProcessadora,
    required this.data,
    required this.hora,
    required this.cliente,
    required this.cartao,
    required this.valor,
    required this.autorizacao,
    required this.prazo,
    required this.tipoOperacao,
    required this.foneCliente,
    required this.tipoParcelamento,
    required this.cetAno,
    required this.prestacao,
  });

  factory ReceiveModel.fromJson(Map<String, dynamic> json) {
    return ReceiveModel(
      terminal: json['terminal'] ?? '',
      lojista: json['lojista'] ?? '',
      cnpj: json['cnpj'] ?? '',
      fone: json['fone'] ?? '',
      endereco: json['endereco'] ?? '',
      nsuTerminal: json['nsuTerminal'] ?? '',
      nsuProcessadora: json['nsuProcessadora'] ?? 0,
      data: json['data'] ?? '',
      hora: json['hora'] ?? '',
      cliente: json['cliente'] ?? '',
      cartao: json['cartao'] ?? '',
      valor: json['valor'] ?? '',
      autorizacao: json['autorizacao'] ?? 0,
      prazo: json['prazo'] ?? 0,
      tipoOperacao: json['tipoOperacao'] ?? '',
      foneCliente: json['foneCliente'] ?? '',
      tipoParcelamento: json['tipoParcelamento'] ?? 0,
      cetAno: json['cetAno'] ?? '',
      prestacao: json['prestacao'] ?? '',
    );
  }
}
