import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/features/configuration/mixin/configuration_page_mixin.dart';
import 'package:zeeppay/features/configuration/presentation/widgets/dropdown_stores.dart';

class ConfigurationPage extends StatefulWidget with ConfigurationPageMixin {
  ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> with ConfigurationPageMixin {
  final _tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _loadToken() {
    final savedToken = getToken();
    if (savedToken != null) {
      _tokenController.text = savedToken;
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
              SizedBox(height: 20),
              Text("Token de Acesso: "),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: TextField(
                  controller: _tokenController,
                  decoration: InputDecoration(
                    hintText: "Digite o token de acesso",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setToken(_tokenController.text);
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
