class DeviceModel {
  final String id;
  final String serialNumber;
  final String brand;
  final String model;
  final String paymentGateway;

  DeviceModel({
    required this.id,
    required this.serialNumber,
    required this.brand,
    required this.model,
    required this.paymentGateway,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      serialNumber: json['serial_number'],
      brand: json['brand'],
      model: json['model'],
      paymentGateway: json['payment_gateway'],
    );
  }

  static List<DeviceModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DeviceModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'brand': brand,
      'model': model,
      'payment_gateway': paymentGateway,
    };
  }
}
