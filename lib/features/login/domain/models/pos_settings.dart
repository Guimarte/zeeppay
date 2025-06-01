import 'package:zeeppay/features/login/domain/models/settings_pos_model.dart';

class PosDataModel {
  final String id;
  final String key;
  final SettingsPosModel settings;
  PosDataModel({required this.id, required this.key, required this.settings});

  factory PosDataModel.fromJson(Map<String, dynamic> json) {
    return PosDataModel(
      id: json['id'] as String,
      key: json['key'] as String,
      settings: SettingsPosModel.fromJson(json['value']),
    );
  }
}
