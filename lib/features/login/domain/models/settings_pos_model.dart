import 'package:zeeppay/features/login/domain/models/network_pos.dart';
import 'package:zeeppay/features/login/domain/models/store_pos_model.dart';
import 'package:zeeppay/features/login/domain/models/theme_pos_model.dart';

class SettingsPosModel {
  final NetworkPos netWork;
  final ThemePosModel themePos;
  final List<StorePosModel> store;

  SettingsPosModel({
    required this.netWork,
    required this.themePos,
    required this.store,
  });

  factory SettingsPosModel.fromJson(Map<String, dynamic> json) {
    return SettingsPosModel(
      netWork: NetworkPos.fromJson(json['network']),
      themePos: ThemePosModel.fromJson(json['theme']),
      store: StorePosModel.fromJsonList(json['store'] as List<dynamic>),
    );
  }
}
