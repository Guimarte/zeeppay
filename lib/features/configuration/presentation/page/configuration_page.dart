import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/configuration/mixin/configuration_page_mixin.dart';
import 'package:zeeppay/features/configuration/presentation/widgets/dropdown_stores.dart';

class ConfigurationPage extends StatelessWidget with ConfigurationPageMixin {
  ConfigurationPage({super.key});

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
              Text("Selecione uma loja: "),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: DropDownStores(
                  stores: posDataStore.settings!.store,
                  onChanged: (store) {
                    setData(store: store);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                child: Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
