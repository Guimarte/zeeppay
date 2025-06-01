class CoordnatesPosModel {
  final String id;
  final double latitude;
  final double longitude;
  final String addressId;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  CoordnatesPosModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.addressId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CoordnatesPosModel.fromJson(Map<String, dynamic> json) {
    return CoordnatesPosModel(
      id: json['id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      addressId: json['address_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}
