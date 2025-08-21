import '../../domain/models/invoice_type.dart';

abstract class InvoiceEvent {}

class SelectInvoiceType extends InvoiceEvent {
  final InvoiceType type;
  
  SelectInvoiceType({required this.type});
}

class StartCardReading extends InvoiceEvent {}

class StopCardReading extends InvoiceEvent {}

class ConsultarClientePorCartao extends InvoiceEvent {
  final String numeroCartao;

  ConsultarClientePorCartao({
    required this.numeroCartao,
  });
}

class ConsultarFaturas extends InvoiceEvent {
  final String numeroCartao;
  final String strProduto;

  ConsultarFaturas({
    required this.numeroCartao,
    required this.strProduto,
  });
}

class ResetInvoice extends InvoiceEvent {}