import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/invoice/domain/models/card_data.dart';
import '../../domain/usecase/invoice_usecase.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceUsecase _usecase;

  InvoiceBloc({required InvoiceUsecase usecase})
    : _usecase = usecase,
      super(InvoiceInitial()) {
    on<SelectInvoiceType>(_onSelectInvoiceType);
    on<StartCardReading>(_onStartCardReading);
    on<StopCardReading>(_onStopCardReading);
    on<ConsultarClientePorCartao>(_onConsultarClientePorCartao);
    on<ConsultarFaturas>(_onConsultarFaturas);
    on<ResetInvoice>(_onResetInvoice);
  }

  void _onSelectInvoiceType(
    SelectInvoiceType event,
    Emitter<InvoiceState> emit,
  ) {
    emit(InvoiceTypeSelected(selectedType: event.type));
  }

  void _onStartCardReading(
    StartCardReading event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(CardReadingInProgress());

    final result = await _usecase.readCard();

    result.fold(
      (failure) =>
          emit(InvoiceError(message: failure.message ?? 'Erro ao ler cartão')),
      (cardData) => emit(CardReadingSuccess(cardData: cardData)),
    );
  }

  void _onStopCardReading(
    StopCardReading event,
    Emitter<InvoiceState> emit,
  ) async {
    final result = await _usecase.stopCardReading();

    result.fold(
      (failure) => emit(
        InvoiceError(message: failure.message ?? 'Erro ao cancelar leitura'),
      ),
      (_) => emit(CardReadingCancelled()),
    );
  }

  void _onConsultarClientePorCartao(
    ConsultarClientePorCartao event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(ConsultandoCliente());

    final result = await _usecase.consultarClientePorCartao(
      numeroCartao: event.numeroCartao,
    );

    result.fold(
      (failure) => emit(
        InvoiceError(message: failure.message ?? 'Erro ao consultar cliente'),
      ),
      (clienteList) {
        // Buscar o cardData do estado anterior se possível
        CardData? cardData;
        if (state is CardReadingSuccess) {
          cardData = (state as CardReadingSuccess).cardData;
        } else {
          // Criar um CardData básico com o número do cartão
          cardData = CardData(number: event.numeroCartao);
        }

        emit(ClienteConsultado(cliente: clienteList, cardData: cardData));
      },
    );
  }

  void _onConsultarFaturas(
    ConsultarFaturas event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(ConsultandoFaturas());

    final result = await _usecase.consultarUltimasFaturas(
      numeroCartao: event.numeroCartao,
      strProduto: event.strProduto,
    );

    result.fold(
      (failure) => emit(
        InvoiceError(message: failure.message ?? 'Erro ao consultar faturas'),
      ),
      (invoiceResponse) =>
          emit(FaturasConsultadas(invoiceResponse: invoiceResponse)),
    );
  }

  void _onResetInvoice(ResetInvoice event, Emitter<InvoiceState> emit) {
    emit(InvoiceInitial());
  }
}
