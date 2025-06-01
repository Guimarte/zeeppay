class StorePosModel {
  final String id;
  final String name;
  final String? attendanceArea;
  final bool public;
  final String? addressId;
  final String? tenantId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  StorePosModel({
    required this.id,
    required this.name,
    this.attendanceArea,
    required this.public,
    this.addressId,
    this.tenantId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory StorePosModel.fromJson(Map<String, dynamic> json) {
    return StorePosModel(
      id: json['id'] as String,
      name: json['name'] as String,
      attendanceArea: json['attendance_area'] as String?,
      public: json['public'] as bool,
      addressId: json['address_id'] as String?,
      tenantId: json['tenant_id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  static List<StorePosModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => StorePosModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
