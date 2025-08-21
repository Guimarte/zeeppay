import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/invoice/domain/usecase/invoice_usecase.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc({required this.invoiceUsecase}) : super(InvoiceInitial()) {
    on<InvoiceConsutaClienteEvent>(_getCliente);
    on<ResetInvoice>(_resetInvoice);
  }

  InvoiceUsecase invoiceUsecase;

  _getCliente(
    InvoiceConsutaClienteEvent event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceLoadingState());
    try {
      final clientes = await invoiceUsecase.call(event.cpf);
      if (clientes.isNotEmpty) {
        final cliente = clientes.first;
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
    emit(InvoiceInitial());
  }
}
