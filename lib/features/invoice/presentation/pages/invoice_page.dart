import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_event.dart';
import 'package:zeeppay/features/invoice/presentation/bloc/invoice_state.dart';
import 'package:zeeppay/features/invoice/presentation/pages/mixin/invoice_page_mixin.dart';
import 'package:zeeppay/features/invoice/presentation/widgets/search_cpf_invoice_widget.dart';
import 'package:zeeppay/features/invoice/presentation/widgets/invoice_display_widget.dart';

class InvoicePage extends StatelessWidget with InvoicePageMixin {
  InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Fatura'),
      ),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is InvoiceDisplayState) {
            return InvoiceDisplayWidget(
              fatura: state.fatura,
              cliente: state.cliente,
              onPayInvoice: () {
                _handlePayInvoice(context, state.fatura);
              },
            );
          } else if (state is InvoiceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
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

  void _handlePayInvoice(BuildContext context, fatura) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Redirecionando para pagamento...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
