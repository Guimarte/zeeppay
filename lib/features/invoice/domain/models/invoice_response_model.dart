class InvoiceResponseModel {
  final bool success;
  final String? message;
  final List<InvoiceData>? invoices;

  InvoiceResponseModel({
    required this.success,
    this.message,
    this.invoices,
  });

  factory InvoiceResponseModel.fromJson(Map<String, dynamic> json) {
    return InvoiceResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      invoices: json['invoices'] != null
          ? (json['invoices'] as List)
              .map((invoice) => InvoiceData.fromJson(invoice))
              .toList()
          : null,
    );
  }
}

class InvoiceData {
  final String? numero;
  final String? dataVencimento;
  final double? valor;
  final String? status;
  final String? descricao;

  InvoiceData({
    this.numero,
    this.dataVencimento,
    this.valor,
    this.status,
    this.descricao,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      numero: json['numero'],
      dataVencimento: json['dataVencimento'],
      valor: json['valor']?.toDouble(),
      status: json['status'],
      descricao: json['descricao'],
    );
  }
}