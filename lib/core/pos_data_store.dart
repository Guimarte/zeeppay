import 'package:zeeppay/shared/models/settings_pos_model.dart';

class SettingsPosDataStore {
  SettingsPosModel? _settings;

  static final SettingsPosDataStore _instance =
      SettingsPosDataStore._internal();

  factory SettingsPosDataStore() {
    return _instance;
  }

  SettingsPosDataStore._internal();

  SettingsPosModel? get settings => _settings;

  set posData(SettingsPosModel? data) {
    _settings = data;
  }

  bool get hasData => _settings != null;

  void clear() {
    _settings = null;
  }
}
