import 'package:flutter/material.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_event.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_state.dart';
import 'package:zeeppay/shared/models/payment_method.dart';

class PaymentMethodSelectionWidget extends StatelessWidget {
  const PaymentMethodSelectionWidget({
    super.key,
    required this.selectedPaymentMethod,
    required this.invoiceBloc,
  });

  final String? selectedPaymentMethod;
  final InvoiceBloc invoiceBloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selecione a forma de pagamento',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildPaymentMethodGrid(context),
            if (selectedPaymentMethod != null) ...[
              Text(
                'Forma selecionada: $selectedPaymentMethod',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final currentState = invoiceBloc.state;

                  if (currentState is InvoicePaymentMethodSelectionState &&
                      currentState.cardNumber != null &&
                      currentState.fatura != null) {
                    PaymentMethod paymentMethod;
                    switch (selectedPaymentMethod) {
                      case 'PIX':
                        paymentMethod = PaymentMethod.pix;
                        break;
                      case 'Débito':
                        paymentMethod = PaymentMethod.debit;
                        break;
                      case 'Crédito':
                        paymentMethod = PaymentMethod.credit;
                        break;
                      case 'Dinheiro':
                        paymentMethod = PaymentMethod.money;
                        break;
                      default:
                        paymentMethod = PaymentMethod.pix;
                    }

                    invoiceBloc.add(
                      InvoiceRegisterTransactionEvent(
                        cardNumber: currentState.cardNumber!,
                        amount: currentState.fatura!.valor,
                        paymentMethod: paymentMethod,
                        customerCpf: currentState.cliente?.cpf,
                        invoiceId: currentState.fatura!.numeroFatura.toString(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Continuar Pagamento',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodGrid(BuildContext context) {
    final paymentMethods = [
      {'name': 'PIX', 'icon': Icons.pix},
      {'name': 'Débito', 'icon': Icons.credit_card},
      {'name': 'Crédito', 'icon': Icons.credit_card_outlined},
      {'name': 'Dinheiro', 'icon': Icons.attach_money},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: paymentMethods.length,
          itemBuilder: (context, index) {
            final method = paymentMethods[index];
            final isSelected = selectedPaymentMethod == method['name'];

            return GestureDetector(
              onTap: () {
                invoiceBloc.add(
                  InvoiceSelectPaymentMethodEvent(
                    paymentMethod: method['name'] as String,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.1),
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Icon(
                          method['icon'] as IconData,
                          size: 28,
                          color: isSelected ? Colors.green : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: Text(
                          method['name'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? Colors.green : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
