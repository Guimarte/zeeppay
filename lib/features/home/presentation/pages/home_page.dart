import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/home/presentation/mixin/home_page_mixin.dart';
import 'package:zeeppay/features/home/presentation/widgets/drawer_home_widget.dart';
import 'package:zeeppay/features/home/presentation/widgets/options_menu_home_widget.dart';
import 'package:zeeppay/shared/widgets/card_widget.dart';

class HomePage extends StatelessWidget with HomePageMixin {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = SettingsPosDataStore().settings!.themePos.logo;

    return SafeArea(
      child: Scaffold(
        drawer: DrawerHomeWidget(
          cancelButtonFunction: () {
            showCancelDialog(context);
          },
          settingsButtonFunction: () {
            context.push('/settings');
          },
          closeCashier: () {
            showCloseCashierDialog(context);
          },
          testPrintFunction: () {
            Navigator.pop(context);
            testPrint(context);
          },
        ),
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OptionsMenuHomeWidget(
                      function: () {
                        openDrawer(context);
                      },
                    ),

                    CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: logoUrl,
                      height: 100,
                      fit: BoxFit.contain,
                    ),

                    Text(
                      'Bem-vindo!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Escolha uma opção abaixo:',
                      style: theme.textTheme.bodyMedium,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CardWidget(
                            cardName: "VENDA",
                            icon: Icons.attach_money,
                            onTap: () {
                              context.push('/payments');
                            },
                          ),
                        ),
                        Expanded(
                          child: CardWidget(
                            cardName: "PERFIL",
                            icon: Icons.person,
                            onTap: () {
                              context.push('/profile');
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CardWidget(
                            cardName: "FATURA",
                            icon: Icons.shopping_cart,
                            onTap: () {
                              context.push('/invoice');
                            },
                          ),
                        ),
                        Expanded(
                          child: CardWidget(
                            cardName: "CAIXA",
                            icon: Icons.point_of_sale,
                            onTap: () {
                              context.push('/cashier');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
