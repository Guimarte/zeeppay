import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zeeppay/core/pos_data_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height * 1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 32,
            children: [
              CachedNetworkImage(
                imageUrl: PosDataStore().posData!.settings.themePos.logo,
              ),
              Text("VENDAS"),
              Text("PERFIL"),
            ],
          ),
        ),
      ),
    );
  }
}
