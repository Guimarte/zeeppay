import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/configuration/mixin/configuration_page_mixin.dart';
import 'package:zeeppay/features/configuration/presentation/widgets/dropdown_stores.dart';
import 'package:zeeppay/shared/models/device_pos_model.dart';

class ConfigurationPage extends StatefulWidget with ConfigurationPageMixin {
  ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage>
    with ConfigurationPageMixin {
  DeviceModel? selectedDevice;

  @override
  void initState() {
    super.initState();
    _loadSelectedDevice();
  }

  void _loadSelectedDevice() {
    final savedDeviceId = getSelectedDevice();
    if (savedDeviceId != null && posDataStore.settings?.devices != null) {
      try {
        selectedDevice = posDataStore.settings!.devices!.firstWhere(
          (device) => device.id == savedDeviceId,
        );
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tela de Configuração'),
          centerTitle: true,
        ),
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Selecione uma loja: "),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: DropDownStores(
                  stores: posDataStore.settings!.store,
                  onChanged: (store) {
                    setData(store: store);
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text("Selecione um POS: "),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: _buildDeviceDropdown(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedDevice != null) {
                    setSelectedDevice(selectedDevice!.id);
                  }
                  context.go('/home');
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceDropdown() {
    final devices = posDataStore.settings?.devices;

    if (devices == null || devices.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "- Nenhum POS cadastrado",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return DropdownButtonFormField<DeviceModel>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: selectedDevice,
      hint: const Text("Selecione um POS"),
      items: devices.map((device) {
        return DropdownMenuItem<DeviceModel>(
          value: device,
          child: Text(
            "${device.brand} ${device.model} (${device.serialNumber})",
          ),
        );
      }).toList(),
      onChanged: (DeviceModel? device) {
        setState(() {
          selectedDevice = device;
        });
      },
    );
  }
}
