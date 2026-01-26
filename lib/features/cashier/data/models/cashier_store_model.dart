class CashierStoreModel {
  String? id;
  String? name;
  String? document;
  String? address;
  String? phone;

  CashierStoreModel({
    this.id,
    this.name,
    this.document,
    this.address,
    this.phone,
  });

  factory CashierStoreModel.fromJson(Map<String, dynamic> json) {
    return CashierStoreModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      document: json['document'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'document': document,
      'address': address,
      'phone': phone,
    };
  }
}
