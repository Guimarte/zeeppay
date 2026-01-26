class PaymentsSummaryModel {
  double? totalPaymentsAmount;
  double? totalPaymentsByPix;
  double? totalPaymentsByCreditCard;
  double? totalPaymentsByDebitCard;
  double? totalPaymentsByCash;
  double? totalPaymentsByCheck;
  double? totalPaymentsByTransfer;
  double? totalPaymentsValue;
  double? paymentsValueByPix;
  double? paymentsValueByCreditCard;
  double? paymentsValueByDebitCard;
  double? paymentsValueByCash;
  double? paymentsValueByCheck;
  double? paymentsValueByTransfer;

  PaymentsSummaryModel({
    this.totalPaymentsAmount,
    this.totalPaymentsByPix,
    this.totalPaymentsByCreditCard,
    this.totalPaymentsByDebitCard,
    this.totalPaymentsByCash,
    this.totalPaymentsByCheck,
    this.totalPaymentsByTransfer,
    this.totalPaymentsValue,
    this.paymentsValueByPix,
    this.paymentsValueByCreditCard,
    this.paymentsValueByDebitCard,
    this.paymentsValueByCash,
    this.paymentsValueByCheck,
    this.paymentsValueByTransfer,
  });

  factory PaymentsSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentsSummaryModel(
      totalPaymentsAmount: json['totalPaymentsAmount'] as double?,
      totalPaymentsByPix: json['totalPaymentsByPix'] as double?,
      totalPaymentsByCreditCard: json['totalPaymentsByCreditCard'] as double?,
      totalPaymentsByDebitCard: json['totalPaymentsByDebitCard'] as double?,
      totalPaymentsByCash: json['totalPaymentsByCash'] as double?,
      totalPaymentsByCheck: json['totalPaymentsByCheck'] as double?,
      totalPaymentsByTransfer: json['totalPaymentsByTransfer'] as double?,
      totalPaymentsValue: (json['totalPaymentsValue'] as double?),
      paymentsValueByPix: (json['paymentsValueByPix'] as double?),
      paymentsValueByCreditCard: (json['paymentsValueByCreditCard'] as double?),
      paymentsValueByDebitCard: (json['paymentsValueByDebitCard'] as double?),
      paymentsValueByCash: (json['paymentsValueByCash'] as double?),
      paymentsValueByCheck: (json['paymentsValueByCheck'] as double?),
      paymentsValueByTransfer: (json['paymentsValueByTransfer'] as double?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPaymentsAmount': totalPaymentsAmount,
      'totalPaymentsByPix': totalPaymentsByPix,
      'totalPaymentsByCreditCard': totalPaymentsByCreditCard,
      'totalPaymentsByDebitCard': totalPaymentsByDebitCard,
      'totalPaymentsByCash': totalPaymentsByCash,
      'totalPaymentsByCheck': totalPaymentsByCheck,
      'totalPaymentsByTransfer': totalPaymentsByTransfer,
      'totalPaymentsValue': totalPaymentsValue,
      'paymentsValueByPix': paymentsValueByPix,
      'paymentsValueByCreditCard': paymentsValueByCreditCard,
      'paymentsValueByDebitCard': paymentsValueByDebitCard,
      'paymentsValueByCash': paymentsValueByCash,
      'paymentsValueByCheck': paymentsValueByCheck,
      'paymentsValueByTransfer': paymentsValueByTransfer,
    };
  }
}
