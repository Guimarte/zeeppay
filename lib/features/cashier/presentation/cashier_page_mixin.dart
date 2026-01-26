import 'package:flutter/material.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/cashier/cashier.dart';
import 'package:zeeppay/shared/service/configuration_service.dart';
import 'package:zeeppay/shared/models/device_pos_model.dart';

mixin CashierPageMixin<T extends StatefulWidget> on State<T> {
  final CashierBloc cashierBloc = getIt<CashierBloc>();
  final ConfigurationService configService = getIt<ConfigurationService>();

  DeviceModel? selectedDevice;

  @override
  void initState() {
    super.initState();
    _loadDeviceConfiguration();
    selectedDevice = configService.getDeviceData();

    if (selectedDevice != null) {
      cashierBloc.add(
        CashierEventGetCurrentSession(deviceId: selectedDevice!.id),
      );
    }
  }

  void _loadDeviceConfiguration() {
    selectedDevice = configService.getDeviceData();
  }

  @override
  void dispose() {
    cashierBloc.close();
    super.dispose();
  }
}
