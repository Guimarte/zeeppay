import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/theme/colors_app.dart';

class DrawerHomeWidget extends StatelessWidget {
  DrawerHomeWidget({
    super.key,
    required this.cancelButtonFunction,
    required this.settingsButtonFunction,
  });
  Function() cancelButtonFunction;
  Function() settingsButtonFunction;

  final appColor = GetIt.instance.get<ColorsApp>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: appColor.primary),
            child: Text('Menu'),
          ),
          ListTile(
            leading: Icon(Icons.money_off_csred),
            title: Text('Cancelar Venda'),
            onTap: () {
              cancelButtonFunction();
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              settingsButtonFunction();
            },
          ),
        ],
      ),
    );
  }
}
