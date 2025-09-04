import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/features/profile/domain/models/fatura_model.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class ClienteConsultado extends InvoiceState {
  final List<ClienteModel> cliente;
  final String cpf;

  ClienteConsultado({required this.cliente, required this.cpf});
}

class InvoiceDisplayState extends InvoiceState {
  final FaturaModel fatura;
  final ClienteModel cliente;

  InvoiceDisplayState({required this.fatura, required this.cliente});
}

class InvoiceLoadingState extends InvoiceState {}

class InvoiceError extends InvoiceState {
  final String message;

  InvoiceError({required this.message});
}

class InvoiceReadingCardState extends InvoiceState {}

class InvoiceCardReadState extends InvoiceState {
  final String cardNumber;
  final FaturaModel? fatura;
  final ClienteModel? cliente;

  InvoiceCardReadState({
    required this.cardNumber,
    this.fatura,
    this.cliente,
  });
}

class InvoicePaymentProcessingState extends InvoiceState {}

class InvoicePaymentSuccessState extends InvoiceState {
  final String message;

  InvoicePaymentSuccessState({required this.message});
}

class InvoiceRegisterTransactionProcessingState extends InvoiceState {}

class InvoiceRegisterTransactionSuccessState extends InvoiceState {
  final Map<String, dynamic> transactionResult;

  InvoiceRegisterTransactionSuccessState({required this.transactionResult});
}
