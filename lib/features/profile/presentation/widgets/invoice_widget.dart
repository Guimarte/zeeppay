import 'package:flutter/material.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';

class InvoiceCardWidget extends StatelessWidget {
  final ClienteModel client;

  const InvoiceCardWidget({super.key, required this.client});

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
            const Text(
              'Última Fatura',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRow(
              'Data de Vencimento:',
              Formatters.formatDateTime(client.dataUltimaFatura),
            ),
            _buildRow(
              'Data de Fechamento:',
              Formatters.formatDateTime(client.dataProximaFatura),
            ),
            _buildRow(
              'Valor Total:',
              'R\$ ${client.ultimaFatura.valor.toStringAsFixed(2)}',
            ),
            _buildRow(
              'Valor Pago:',
              'R\$ ${client.ultimaFatura.valorPago.toStringAsFixed(2)}',
            ),
            _buildRow('Status:', client.ultimaFatura.situacao),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
