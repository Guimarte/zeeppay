class CashierOperatorModel {
  String? id;
  String? name;

  CashierOperatorModel({
    this.id,
    this.name,
  });

  factory CashierOperatorModel.fromJson(Map<String, dynamic> json) {
    return CashierOperatorModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
