class PurchasesSummaryModel {
  int? totalPurchasesAmount;
  double? totalPurchasesValue;

  PurchasesSummaryModel({
    this.totalPurchasesAmount,
    this.totalPurchasesValue,
  });

  factory PurchasesSummaryModel.fromJson(Map<String, dynamic> json) {
    return PurchasesSummaryModel(
      totalPurchasesAmount: json['totalPurchasesAmount'] as int?,
      totalPurchasesValue: (json['totalPurchasesValue'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPurchasesAmount': totalPurchasesAmount,
      'totalPurchasesValue': totalPurchasesValue,
    };
  }
}
