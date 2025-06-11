import 'dart:convert';

import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/models/store_pos_model.dart';

mixin ConfigurationPageMixin {
  SettingsPosDataStore get posDataStore => SettingsPosDataStore();
  final database = getIt<Database>();

  void setData({required StorePosModel store}) {
    database.setString("store", json.encode(store.toJson()));
  }
}
