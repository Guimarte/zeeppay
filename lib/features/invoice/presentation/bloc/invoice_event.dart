abstract class InvoiceEvent {}

class InvoiceConsutaClienteEvent extends InvoiceEvent {
  final String cpf;

  InvoiceConsutaClienteEvent({required this.cpf});
}

class ResetInvoice extends InvoiceEvent {}
