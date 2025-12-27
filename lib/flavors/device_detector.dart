import 'package:flutter/foundation.dart';
import 'package:zeeppay/flavors/flavor_config.dart';

class DeviceDetector {
  static DeviceModel detectDeviceModel() {
    // Pega direto do build usando --dart-define=DEVICE_MODEL=gpos760
    const deviceModel = String.fromEnvironment('DEVICE_MODEL', defaultValue: '');

    if (kDebugMode) {
      print('Device Model detectado: $deviceModel');
    }

    switch (deviceModel.toLowerCase()) {
      case 'gpos760':
        return DeviceModel.gpos760;
      case 'gpos780':
        return DeviceModel.gpos780;
      default:
        if (kDebugMode) {
          print('Device model não definido. Use --dart-define=DEVICE_MODEL=gpos760 ou gpos780');
        }
        return DeviceModel.unknown;
    }
  }
}
