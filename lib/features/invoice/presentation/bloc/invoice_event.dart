import 'package:zeeppay/shared/models/payment_method.dart';

abstract class InvoiceEvent {}

class InvoiceConsutaClienteEvent extends InvoiceEvent {
  final String cpf;

  InvoiceConsutaClienteEvent({required this.cpf});
}

class ResetInvoice extends InvoiceEvent {}

class InvoiceReadCardEvent extends InvoiceEvent {}

class InvoicePayEvent extends InvoiceEvent {
  final String cardNumber;
  final double amount;
  final String paymentType;

  InvoicePayEvent({
    required this.cardNumber,
    required this.amount,
    required this.paymentType,
  });
}

class InvoiceRegisterTransactionEvent extends InvoiceEvent {
  final String cardNumber;
  final double amount;
  final PaymentMethod paymentMethod;
  final String? customerCpf;
  final String? invoiceId;

  InvoiceRegisterTransactionEvent({
    required this.cardNumber,
    required this.amount,
    required this.paymentMethod,
    this.customerCpf,
    this.invoiceId,
  });
}
