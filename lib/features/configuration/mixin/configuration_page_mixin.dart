import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';
import 'package:zeeppay/shared/models/device_pos_model.dart';
import 'package:zeeppay/shared/service/configuration_service.dart';

mixin ConfigurationPageMixin {
  SettingsPosDataStore get posDataStore => SettingsPosDataStore();
  final configService = getIt<ConfigurationService>();

  void setData({required StorePosModel store}) {
    configService.setStore(store);
  }

  void setSelectedDevice(String deviceId) {
    configService.setSelectedDevice(deviceId);
  }

  String? getSelectedDevice() {
    return configService.getSelectedDeviceId();
  }

  void setDeviceData(DeviceModel device) {
    configService.setDeviceData(device);
  }

  DeviceModel? getDeviceData() {
    return configService.getDeviceData();
  }

  String? getDeviceId() {
    return configService.getDeviceId();
  }

  StorePosModel? getSavedStore() {
    return configService.getStore();
  }

  StorePosModel? getInitialStore(List<StorePosModel> stores) {
    return configService.getInitialStore(stores);
  }
}
