import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/widgets/card_widget.dart';

class InitialProfileWidget extends StatelessWidget {
  const InitialProfileWidget({super.key, required this.function, required this.onBack});
  final Function() function;
  final Function() onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoUrl = SettingsPosDataStore().settings!.themePos.logo;

    return SafeArea(
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    onPressed: onBack,
                  ),
                  const Spacer(),
                ],
              ),
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
                children: [
                  Expanded(
                    child: CardWidget(
                      icon: Icons.badge,
                      cardName: "CPF",
                      onTap: function,
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
