enum Flavor {
  yano,
  bandcard,
  jbcard,
  taustepay,
  queirozpremium,
  devee,
  tridicopay,
  sindbank,
}

enum DeviceModel {
  gpos760,
  gpos780,
  unknown,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String subdomain;
  final DeviceModel? deviceModel;

  static late FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String subdomain,
    DeviceModel? deviceModel,
  }) {
    _instance = FlavorConfig._internal(flavor, name, subdomain, deviceModel);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.subdomain, this.deviceModel);

  static FlavorConfig get instance => _instance;

  /// Retorna true se o dispositivo tem teclado físico
  bool get hasPhysicalKeyboard {
    return deviceModel == DeviceModel.gpos760;
  }

  /// Retorna true se deve usar teclado virtual
  bool get shouldUseVirtualKeyboard {
    return !hasPhysicalKeyboard;
  }
}
