import 'package:flutter/material.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/features/profile/domain/models/fatura_model.dart';
import 'package:intl/intl.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';
import 'package:zeeppay/shared/widgets/primary_button.dart';

class InvoiceDisplayWidget extends StatelessWidget {
  final FaturaModel fatura;
  final ClienteModel cliente;
  final VoidCallback onPayInvoice;

  const InvoiceDisplayWidget({
    super.key,
    required this.fatura,
    required this.cliente,
    required this.onPayInvoice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dados do Cliente',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Nome:', cliente.nome),
                  _buildInfoRow('CPF:', cliente.cpf),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fatura ${fatura.numeroFatura}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildInfoRow(
                    'Vencimento:',
                    Formatters.formatDateTime(
                      fatura.dataVencimento,
                      'dd/MM/yyyy',
                    ),
                  ),
                  _buildInfoRow('Situação:', fatura.descricaoSituacao),
                  const Divider(),
                  _buildInfoRow(
                    'Valor Total:',
                    Formatters.formatCurrency(fatura.valor),
                    isHighlight: true,
                  ),
                  _buildInfoRow(
                    'Valor Pago:',
                    Formatters.formatCurrency(fatura.valorPago),
                  ),
                  _buildInfoRow(
                    'Saldo Devedor:',
                    Formatters.formatCurrency(fatura.saldoDevedor),
                  ),
                  _buildInfoRow(
                    'Valor Mínimo:',
                    Formatters.formatCurrency(fatura.valorMinimo),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          PrimaryButton(
            buttonName: "Pagar Fatura",
            functionPrimaryButton: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: isHighlight ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              fontSize: isHighlight ? 16 : 14,
              color: isHighlight ? Colors.green[700] : null,
            ),
          ),
        ],
      ),
    );
  }
}
