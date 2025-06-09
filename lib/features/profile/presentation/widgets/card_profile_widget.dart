import 'package:flutter/material.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';

class CardProfileWidget extends StatelessWidget {
  const CardProfileWidget({super.key, required this.client});
  final ClienteModel client;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.nomeReduzido,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(client.email, style: const TextStyle(color: Colors.grey)),
            Text(
              '(${client.ddd1}) ${client.telefone1}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Situação: ${client.situacao}'),
                Text('Score: ${client.score}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
