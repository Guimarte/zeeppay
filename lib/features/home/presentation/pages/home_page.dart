import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/widgets/card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = SettingsPosDataStore().settings!.themePos.logo;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                CachedNetworkImage(
                  imageUrl: logoUrl,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                Text(
                  'Bem-vindo!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Escolha uma opção abaixo:',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CardWidget(
                        cardName: "VENDAS",
                        icon: Icons.shopping_cart,
                        onTap: () {
                          context.push('/payments');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
