// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/features/profile/domain/models/fatura_model.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';
import 'package:zeeppay/shared/widgets/primary_button.dart';

class InvoiceDisplayWidget extends StatefulWidget {
  final FaturaModel fatura;
  final ClienteModel cliente;
  final VoidCallback onPayInvoice;
  final InvoiceBloc invoiceBloc;

  const InvoiceDisplayWidget({
    super.key,
    required this.fatura,
    required this.cliente,
    required this.onPayInvoice,
    required this.invoiceBloc,
  });

  @override
  State<InvoiceDisplayWidget> createState() => _InvoiceDisplayWidgetState();
}

class _InvoiceDisplayWidgetState extends State<InvoiceDisplayWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
                  _buildInfoRow('Nome:', widget.cliente.nome),
                  _buildInfoRow('CPF:', widget.cliente.cpf),
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
                    'Fatura ${widget.fatura.numeroFatura}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildInfoRow(
                    'Vencimento:',
                    Formatters.formatDateTime(
                      widget.fatura.dataVencimento,
                      'dd/MM/yyyy',
                    ),
                  ),
                  _buildInfoRow('Situação:', widget.fatura.descricaoSituacao),
                  const Divider(),
                  _buildInfoRow(
                    'Valor Total:',
                    Formatters.formatCurrency(widget.fatura.valor),
                    isHighlight: true,
                  ),
                  _buildInfoRow(
                    'Valor Pago:',
                    Formatters.formatCurrency(widget.fatura.valorPago),
                  ),
                  _buildInfoRow(
                    'Saldo Devedor:',
                    Formatters.formatCurrency(widget.fatura.saldoDevedor),
                  ),
                  _buildInfoRow(
                    'Valor Mínimo:',
                    Formatters.formatCurrency(widget.fatura.valorMinimo),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
          PrimaryButton(
            buttonName: "Pagar Fatura",
            functionPrimaryButton: widget.onPayInvoice,
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
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
                fontSize: isHighlight ? 16 : 14,
                color: isHighlight ? Colors.green[700] : null,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
