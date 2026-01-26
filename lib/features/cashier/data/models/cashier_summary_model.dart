import 'payments_summary_model.dart';
import 'purchases_summary_model.dart';

class CashierSummaryModel {
  PaymentsSummaryModel? paymentsSummary;
  PurchasesSummaryModel? purchasesSummary;
  String? openDate;
  String? closeDate;
  int? durationInSeconds;

  CashierSummaryModel({
    this.paymentsSummary,
    this.purchasesSummary,
    this.openDate,
    this.closeDate,
    this.durationInSeconds,
  });

  factory CashierSummaryModel.fromJson(Map<String, dynamic> json) {
    return CashierSummaryModel(
      paymentsSummary: json['paymentsSummary'] != null
          ? PaymentsSummaryModel.fromJson(
              json['paymentsSummary'] as Map<String, dynamic>)
          : null,
      purchasesSummary: json['purchasesSummary'] != null
          ? PurchasesSummaryModel.fromJson(
              json['purchasesSummary'] as Map<String, dynamic>)
          : null,
      openDate: json['openDate'] as String?,
      closeDate: json['closeDate'] as String?,
      durationInSeconds: json['durationInSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentsSummary': paymentsSummary?.toJson(),
      'purchasesSummary': purchasesSummary?.toJson(),
      'openDate': openDate,
      'closeDate': closeDate,
      'durationInSeconds': durationInSeconds,
    };
  }
}
