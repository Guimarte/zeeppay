import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_event.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_state.dart';
import 'package:zeeppay/features/invoice/presentation/pages/mixin/invoice_page_mixin.dart';
import 'package:zeeppay/features/invoice/presentation/widgets/search_cpf_invoice_widget.dart';
import 'package:zeeppay/features/invoice/presentation/widgets/invoice_display_widget.dart';
import 'package:zeeppay/features/invoice/presentation/widgets/payment_method_selection_widget.dart';
import 'package:zeeppay/shared/widgets/payments_insert_card_widget.dart';
import 'package:zeeppay/shared/validators/cpf_validator.dart';

class InvoicePage extends StatelessWidget with InvoicePageMixin {
  InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta de Fatura')),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        bloc: invoiceBloc,
        builder: (context, state) {
          if (state is InvoiceInitial) {
            return SearchCpfInvoiceWidget(
              cpfController: cpfController,
              onConfirm: () {
                if (!CpfValidator.isValid(cpfController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, digite um CPF válido'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final cleanCpf = CpfValidator.cleanCpf(cpfController.text);
                invoiceBloc.add(
                  InvoiceConsutaClienteEvent(cpf: cleanCpf),
                );
              },
            );
          } else if (state is InvoiceLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InvoiceDisplayState) {
            return InvoiceDisplayWidget(
              fatura: state.fatura,
              cliente: state.cliente,
              invoiceBloc: invoiceBloc,
              onPayInvoice: () {
                invoiceBloc.add(InvoiceReadCardEvent());
              },
            );
          } else if (state is InvoiceReadingCardState) {
            return InsertCardWidget(bloc: invoiceBloc, function: () {});
          } else if (state is InvoicePaymentMethodSelectionState) {
            return PaymentMethodSelectionWidget(
              selectedPaymentMethod: state.selectedPaymentMethod,
              invoiceBloc: invoiceBloc,
            );
          } else if (state is InvoiceRegisterTransactionProcessingState) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processando transação...'),
                ],
              ),
            );
          } else if (state is InvoiceRegisterTransactionSuccessState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    'Transação registrada com sucesso!',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      invoiceBloc.add(ResetInvoice());
                    },
                    child: const Text('Nova Consulta'),
                  ),
                ],
              ),
            );
          } else if (state is InvoiceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      invoiceBloc.add(ResetInvoice());
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
