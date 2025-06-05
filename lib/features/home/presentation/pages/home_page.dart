import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/home/presentation/widgets/card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height * 1,
          child: Center(
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: PosDataStore().posData!.settings.themePos.logo,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CardWidget(
                      cardName: "VENDAS",
                      onTap: () {
                        context.go('/payments');
                        // PrinterService.printReceive();
                      },
                    ),
                    CardWidget(cardName: "PERFIL", onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
