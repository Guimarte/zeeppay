import 'package:zeeppay/features/login/domain/models/coordnates_pos_model.dart';

class AddressPosModel {
  final String id;
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final CoordnatesPosModel? coordinates;

  AddressPosModel({
    required this.id,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.coordinates,
  });

  factory AddressPosModel.fromJson(Map<String, dynamic> json) {
    return AddressPosModel(
      id: json['id'],
      street: json['street'],
      number: json['number'],
      complement: json['complement'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      coordinates: json['coordinates'] != null
          ? CoordnatesPosModel.fromJson(json['coordinates'])
          : null,
    );
  }
}
