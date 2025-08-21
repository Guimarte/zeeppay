import 'package:zeeppay/shared/models/device_pos_model.dart';
import 'package:zeeppay/shared/models/ercards_pos.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';
import 'package:zeeppay/shared/models/theme_pos_model.dart';

class SettingsPosModel {
  final ERCardsModel erCardsModel;
  final ThemePosModel themePos;
  final List<StorePosModel> store;
  final List<DeviceModel>? devices;

  SettingsPosModel({
    required this.erCardsModel,
    required this.themePos,
    required this.store,
    this.devices,
  });

  factory SettingsPosModel.fromJson(Map<String, dynamic> json) {
    return SettingsPosModel(
      erCardsModel: ERCardsModel.fromJson(json['network']),
      themePos: ThemePosModel.fromJson(json['theme']),
      store: StorePosModel.fromJsonList(json['store'] as List<dynamic>),
      devices: json['devices'] != null ? DeviceModel.fromJsonList(json['devices'] as List<dynamic>) : null,
    );
  }
}
