class CashierDeviceModel {
  String? id;
  String? name;
  String? serialNumber;

  CashierDeviceModel({
    this.id,
    this.name,
    this.serialNumber,
  });

  factory CashierDeviceModel.fromJson(Map<String, dynamic> json) {
    return CashierDeviceModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      serialNumber: json['serialNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serialNumber': serialNumber,
    };
  }
}
