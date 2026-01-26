import 'dart:convert';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/models/device_pos_model.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';

class ConfigurationService {
  final Database database;

  ConfigurationService(this.database);

  // Device methods
  void setSelectedDevice(String deviceId) {
    database.setString("selected_device", deviceId);
  }

  String? getSelectedDeviceId() {
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

  // Store methods
  void setStore(StorePosModel store) {
    database.setString("store", json.encode(store.toJson()));
  }

  StorePosModel? getStore() {
    final storeJson = database.getString("store");
    if (storeJson != null) {
      return StorePosModel.fromJson(json.decode(storeJson));
    }
    return null;
  }

  StorePosModel? getInitialStore(List<StorePosModel> stores) {
    if (stores.isEmpty) return null;

    final savedStore = getStore();
    if (savedStore != null) {
      try {
        return stores.firstWhere(
          (store) => store.name == savedStore.name,
        );
      } catch (e) {
        return stores.first;
      }
    }

    return stores.first;
  }
}
