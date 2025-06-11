enum Flavor {
  yano,
  bandcard,
  jbcard,
  taustepay,
  queirozpremium,
  devee,
  tridicopay,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String subdomain;

  static late FlavorConfig _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String subdomain,
  }) {
    _instance = FlavorConfig._internal(flavor, name, subdomain);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.name, this.subdomain);

  static FlavorConfig get instance => _instance;
}
