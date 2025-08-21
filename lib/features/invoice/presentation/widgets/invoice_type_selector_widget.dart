import 'package:flutter/material.dart';
import '../../domain/models/invoice_type.dart';
import '../../../../shared/widgets/card_widget.dart';

class InvoiceTypeSelectorWidget extends StatelessWidget {
  final Function(InvoiceType) onTypeSelected;

  const InvoiceTypeSelectorWidget({
    super.key,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Selecione o tipo de consulta:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: CardWidget(
                cardName: "CPF",
                icon: Icons.person,
                onTap: () => onTypeSelected(InvoiceType.cpf),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CardWidget(
                cardName: "CARTÃO",
                icon: Icons.credit_card,
                onTap: () => onTypeSelected(InvoiceType.card),
              ),
            ),
          ],
        ),
      ],
    );
  }
}