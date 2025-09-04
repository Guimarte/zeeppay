import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_event.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_state.dart';
import 'package:zeeppay/features/invoice/presentation/pages/mixin/invoice_page_mixin.dart';
import 'package:zeeppay/features/invoice/presentation/widgets/search_cpf_invoice_widget.dart';
import 'package:zeeppay/features/invoice/presentation/widgets/invoice_display_widget.dart';
import 'package:zeeppay/shared/widgets/payments_insert_card_widget.dart';
import 'package:zeeppay/shared/models/payment_method.dart';

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
                invoiceBloc.add(
                  InvoiceConsutaClienteEvent(cpf: cpfController.text),
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
          } else if (state is InvoiceCardReadState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              invoiceBloc.add(
                InvoiceRegisterTransactionEvent(
                  cardNumber: state.cardNumber,
                  amount: state.fatura?.saldoDevedor?.toDouble() ?? 0.0,
                  paymentMethod: PaymentMethod.credit,
                  customerCpf: state.cliente?.cpf,
                  invoiceId: state.fatura?.numeroFatura?.toString(),
                ),
              );
            });
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cartão lido com sucesso!\nRegistrando transação...'),
                ],
              ),
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
