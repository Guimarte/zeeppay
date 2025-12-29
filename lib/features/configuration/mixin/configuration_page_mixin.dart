import 'dart:convert';

import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';
import 'package:zeeppay/shared/models/device_pos_model.dart';

mixin ConfigurationPageMixin {
  SettingsPosDataStore get posDataStore => SettingsPosDataStore();
  final database = getIt<Database>();

  void setData({required StorePosModel store}) {
    database.setString("store", json.encode(store.toJson()));
  }

  void setSelectedDevice(String deviceId) {
    database.setString("selected_device", deviceId);
  }

  String? getSelectedDevice() {
    return database.getString("selected_device");
  }

  void setDeviceData(DeviceModel device) {
    database.setString("device_data", json.encode(device.toJson()));
    database.setString("device_id", device.id);
  }

  DeviceModel? getDeviceData() {
    final deviceJson = database.getString("device_data");
    if (deviceJson != null) {
      return DeviceModel.fromJson(json.decode(deviceJson));
    }
    return null;
  }

  String? getDeviceId() {
    return database.getString("device_id");
  }

  StorePosModel? getSavedStore() {
    final storeJson = database.getString("store");
    if (storeJson != null) {
      return StorePosModel.fromJson(json.decode(storeJson));
    }
    return null;
  }

  StorePosModel? getInitialStore(List<StorePosModel> stores) {
    if (stores.isEmpty) return null;

    final savedStore = getSavedStore();
    if (savedStore != null) {
      // Procura uma loja com o mesmo nome
      try {
        return stores.firstWhere(
          (store) => store.name == savedStore.name,
        );
      } catch (e) {
        // Se não encontrar loja com o mesmo nome, retorna a primeira
        return stores.first;
      }
    }

    // Se não tiver loja salva, retorna a primeira
    return stores.first;
  }
}
