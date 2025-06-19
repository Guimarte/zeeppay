class SuccessTransactModel {
  final int nsuOperacao;
  final String textoContrato;
  final String textContratoSeguro;

  SuccessTransactModel({
    required this.nsuOperacao,
    required this.textoContrato,
    required this.textContratoSeguro,
  });

  factory SuccessTransactModel.fromJson(Map<String, dynamic> json) {
    return SuccessTransactModel(
      nsuOperacao: json['lngNsuOperacao'],
      textoContrato: json['strTextoContrato'],
      textContratoSeguro: json['strTextoContratoSeguro'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'lngNsuOperacao': nsuOperacao,
      'strTextoContrato': textoContrato,
      'strTextoContratoSeguro': textContratoSeguro,
    };
  }
}
