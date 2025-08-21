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
