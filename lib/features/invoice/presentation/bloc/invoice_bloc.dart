import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/invoice/domain/usecase/invoice_usecase.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/features/profile/domain/models/fatura_model.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';
import 'package:zeeppay/shared/models/register_transaction_model.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc({required this.invoiceUsecase}) : super(InvoiceInitial()) {
    on<InvoiceConsutaClienteEvent>(_getCliente);
    on<ResetInvoice>(_resetInvoice);
    on<InvoiceReadCardEvent>(_readCard);
    on<InvoicePayEvent>(_payInvoice);
    on<InvoiceRegisterTransactionEvent>(_registerTransaction);
  }

  InvoiceUsecase invoiceUsecase;

  // Mantém os dados atuais para uso posterior
  FaturaModel? _currentFatura;
  ClienteModel? _currentCliente;

  _getCliente(
    InvoiceConsutaClienteEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceLoadingState());
    try {
      final clientes = await invoiceUsecase.requestInvoice(event.cpf);
      if (clientes.isNotEmpty) {
        final cliente = clientes.first;
        _currentCliente = cliente;
        _currentFatura = cliente.ultimaFatura;
        emit(
          InvoiceDisplayState(fatura: cliente.ultimaFatura, cliente: cliente),
        );
      } else {
        emit(InvoiceError(message: 'Cliente não encontrado'));
      }
    } catch (e) {
      emit(InvoiceError(message: e.toString()));
    }
  }

  _resetInvoice(ResetInvoice event, Emitter<InvoiceState> emit) {
    _currentCliente = null;
    _currentFatura = null;
    emit(InvoiceInitial());
  }

  Future<void> _readCard(
    InvoiceReadCardEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceReadingCardState());

    try {
      final cardNumber = await GertecService.readCard();

      if (cardNumber.contains('Erro') || cardNumber.contains('cancelada')) {
        emit(InvoiceError(message: cardNumber));
      } else {
        emit(
          InvoiceCardReadState(
            cardNumber: cardNumber,
            fatura: _currentFatura,
            cliente: _currentCliente,
          ),
        );
      }
    } catch (e) {
      emit(InvoiceError(message: 'Erro ao ler cartão: ${e.toString()}'));
    }
  }

  Future<void> _payInvoice(
    InvoicePayEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoicePaymentProcessingState());

    try {
      await Future.delayed(Duration(seconds: 2));

      emit(
        InvoicePaymentSuccessState(message: 'Pagamento realizado com sucesso!'),
      );
    } catch (e) {
      emit(InvoiceError(message: 'Erro no pagamento: ${e.toString()}'));
    }
  }

  Future<void> _registerTransaction(
    InvoiceRegisterTransactionEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceRegisterTransactionProcessingState());

    try {
      final transaction = RegisterTransactionModel(
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        cardNumber: event.cardNumber,
        customerCpf: event.customerCpf,
        invoiceId: event.invoiceId,
      );

      final result = await invoiceUsecase.registerTransaction(transaction);

      emit(InvoiceRegisterTransactionSuccessState(transactionResult: result));
    } catch (e) {
      emit(
        InvoiceError(message: 'Erro ao registrar transação: ${e.toString()}'),
      );
    }
  }
}
