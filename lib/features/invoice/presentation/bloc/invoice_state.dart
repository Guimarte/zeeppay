import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import '../../domain/models/card_data.dart';
import '../../domain/models/invoice_response_model.dart';
import '../../domain/models/invoice_type.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceTypeSelected extends InvoiceState {
  final InvoiceType selectedType;
  
  InvoiceTypeSelected({required this.selectedType});
}

class CardReadingInProgress extends InvoiceState {}

class CardReadingSuccess extends InvoiceState {
  final CardData cardData;
  
  CardReadingSuccess({required this.cardData});
}

class CardReadingCancelled extends InvoiceState {}

class ConsultandoCliente extends InvoiceState {}

class ClienteConsultado extends InvoiceState {
  final List<ClienteModel> cliente;
  final CardData cardData;
  
  ClienteConsultado({
    required this.cliente,
    required this.cardData,
  });
}

class ConsultandoFaturas extends InvoiceState {}

class FaturasConsultadas extends InvoiceState {
  final InvoiceResponseModel invoiceResponse;
  
  FaturasConsultadas({required this.invoiceResponse});
}

class InvoiceError extends InvoiceState {
  final String message;
  
  InvoiceError({required this.message});
}