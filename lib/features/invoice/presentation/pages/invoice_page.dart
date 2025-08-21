import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/invoice_response_model.dart';
import '../../domain/models/invoice_type.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';
import '../widgets/invoice_type_selector_widget.dart';
import '../widgets/card_reading_widget.dart';
import '../widgets/card_success_widget.dart';
import '../../../../shared/widgets/show_dialog_erro_widget.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Fatura'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceError) {
            showErrorDialog(context, message: state.message);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, InvoiceState state) {
    switch (state) {
      case InvoiceInitial _:
      case InvoiceTypeSelected _:
        return _buildTypeSelection(context, state);
      
      case CardReadingInProgress _:
        return CardReadingWidget(
          onCancel: () {
            context.read<InvoiceBloc>().add(StopCardReading());
          },
        );
        
      case CardReadingSuccess successState:
        return CardSuccessWidget(
          cardData: successState.cardData,
          onContinue: () {
            context.read<InvoiceBloc>().add(ConsultarClientePorCartao(
              numeroCartao: successState.cardData.number,
            ));
          },
          onRetry: () {
            context.read<InvoiceBloc>().add(StartCardReading());
          },
        );
        
      case CardReadingCancelled _:
        return _buildTypeSelection(context, state);
        
      case ConsultandoCliente _:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Consultando dados do cliente...'),
            ],
          ),
        );
        
      case ClienteConsultado clienteState:
        return _buildClienteResult(context, clienteState);
        
      case ConsultandoFaturas _:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Consultando faturas...'),
            ],
          ),
        );
        
      case FaturasConsultadas faturaState:
        return _buildFaturasResult(context, faturaState.invoiceResponse);
        
      default:
        return _buildTypeSelection(context, state);
    }
  }

  Widget _buildTypeSelection(BuildContext context, InvoiceState state) {
    return Center(
      child: InvoiceTypeSelectorWidget(
        onTypeSelected: (type) {
          _handleContinue(context, type);
        },
      ),
    );
  }

  void _handleContinue(BuildContext context, InvoiceType type) {
    context.read<InvoiceBloc>().add(SelectInvoiceType(type: type));
    
    switch (type) {
      case InvoiceType.cpf:
        // Navegar para tela de inserir CPF
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funcionalidade de CPF será implementada'),
          ),
        );
        break;
      case InvoiceType.card:
        context.read<InvoiceBloc>().add(StartCardReading());
        break;
    }
  }

  Widget _buildClienteResult(BuildContext context, ClienteConsultado clienteState) {
    if (clienteState.cliente.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Cliente não encontrado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<InvoiceBloc>().add(ResetInvoice());
            },
            child: const Text('Tentar Novamente'),
          ),
        ],
      );
    }

    final cliente = clienteState.cliente.first;
    
    return Column(
      children: [
        const Text(
          'Dados do Cliente',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${cliente.nome}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('CPF: ${cliente.cpf}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Produto: ${cliente.produtoDescricao}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Situação: ${cliente.situacao}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Cartão: ${cliente.numeroCartao}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text(
                    'Deseja consultar as faturas deste cliente?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<InvoiceBloc>().add(ResetInvoice());
                },
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<InvoiceBloc>().add(ConsultarFaturas(
                    numeroCartao: clienteState.cardData.number,
                    strProduto: cliente.produto,
                  ));
                },
                child: const Text('Consultar Faturas'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFaturasResult(BuildContext context, InvoiceResponseModel invoiceResponse) {
    return Column(
      children: [
        const Text(
          'Faturas Encontradas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (invoiceResponse.success && invoiceResponse.invoices != null)
          Expanded(
            child: ListView.builder(
              itemCount: invoiceResponse.invoices!.length,
              itemBuilder: (context, index) {
                final invoice = invoiceResponse.invoices![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('Fatura ${invoice.numero ?? "N/A"}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vencimento: ${invoice.dataVencimento ?? "N/A"}'),
                        Text('Valor: R\$ ${invoice.valor?.toStringAsFixed(2) ?? "N/A"}'),
                        Text('Status: ${invoice.status ?? "N/A"}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        else
          const Text('Nenhuma fatura encontrada ou erro na consulta'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.read<InvoiceBloc>().add(ResetInvoice());
          },
          child: const Text('Nova Consulta'),
        ),
      ],
    );
  }
}
