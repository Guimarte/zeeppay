import 'package:zeeppay/features/login/domain/models/pos_settings.dart';

class PosDataStore {
  PosDataModel? _posData;

  static final PosDataStore _instance = PosDataStore._internal();

  factory PosDataStore() {
    return _instance;
  }

  PosDataStore._internal();

  PosDataModel? get posData => _posData;

  set posData(PosDataModel? data) {
    _posData = data;
  }

  bool get hasData => _posData != null;

  void clear() {
    _posData = null;
  }
}
