import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/widgets/card_widget.dart';

class InitialProfileWidget extends StatelessWidget {
  const InitialProfileWidget({super.key, required this.function});
  final Function() function;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = PosDataStore().posData!.settings.themePos.logo;

    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                'Consultar Perfil',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione como deseja buscar o cliente:',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CardWidget(
                      icon: Icons.badge,
                      cardName: "CPF",
                      onTap: function,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CardWidget(
                      icon: Icons.credit_card,
                      cardName: "Cartão",
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
