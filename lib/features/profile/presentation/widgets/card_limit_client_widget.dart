import 'package:flutter/material.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/features/profile/presentation/widgets/credit_chart_widget.dart';

class CardLimitClientWidget extends StatelessWidget {
  const CardLimitClientWidget({super.key, required this.client});

  final ClienteModel client;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Uso do Limite de Crédito',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CreditChartWidget(
              used: client.limiteUtilizadoCompras,
              available: client.limite,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Utilizado: R\$ ${client.limiteUtilizadoCompras.toStringAsFixed(2)}',
                ),
                Text(
                  'Disponível: R\$ ${client.limiteDisponivelCompras.toStringAsFixed(2)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Limite Total: R\$ ${client.limite.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
