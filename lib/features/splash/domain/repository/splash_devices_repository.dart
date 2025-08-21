import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/device_pos_model.dart';

abstract class SplashDevicesRepository {
  Future<List<DeviceModel>> call();
}

class SplashDevicesRepositoryImpl implements SplashDevicesRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();

  @override
  Future<List<DeviceModel>> call() async {
    final requestDevices = await zeeppayDio.get(
      url: UrlsLogin.devices,
      isStoreRequest: false,
    );

    if (requestDevices.statusCode == 200) {
      return DeviceModel.fromJsonList(requestDevices.data['data']);
    } else {
      throw Exception('Failed to load devices');
    }
  }
}
