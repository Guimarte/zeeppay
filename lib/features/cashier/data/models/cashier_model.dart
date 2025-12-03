class CashierModel {
  String? id;

  CashierModel({this.id});

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(id: json['id'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
