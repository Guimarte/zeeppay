import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/payments/domain/usecase/payments_usecase.dart';
import 'package:zeeppay/features/payments/domain/usecase/printer_receive_usecase.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc({
    required this.paymentsUsecase,
    required this.printerReceiveUseCase,
  }) : super(PaymentsStateInitial()) {
    on<PaymentsEventGetPassword>(_getPassword);
    on<PaymentsEventSetInicialState>(_setInitialState);
    on<PaymentsEventPutValueState>(_setPutValueState);
    on<PaymentsEventPutCardState>(_setPutCardState);
    on<PaymentsEventTransact>(_transact);
    on<PaymentsEventTerm>(_setPaymentTerm);
    on<PaymentsEventErrorCard>(_setPutCardErrorState);
  }

  final PaymentsUsecase paymentsUsecase;
  final PrinterReceiveUseCase printerReceiveUseCase;

  void _setInitialState(PaymentsEventSetInicialState event, Emitter emitter) {
    emitter(PaymentsStateInitial());
  }

  void _setPutCardState(PaymentsEventPutCardState event, Emitter emitter) {
    emitter(PaymentsStatePutCard());
  }

  void _getPassword(PaymentsEventGetPassword event, Emitter emitter) async {
    emitter(PaymentsStatePutPassword());
  }

  void _setPutValueState(PaymentsEventPutValueState event, Emitter emitter) {
    emitter(PaymentsStatePutValue());
  }

  void _setPutCardErrorState(PaymentsEventErrorCard event, Emitter emitter) {
    emitter(PaymentsStateError());
    emitter(PaymentsStatePutValue());
  }

  Future<void> _transact(PaymentsEventTransact event, Emitter emitter) async {
    emitter(PaymentsStateLoading());

    final result = await paymentsUsecase.call(event.sellModel);

    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => throw Exception());
      emitter(PaymentsStateError(error: failure.message));
      return;
    }

    final success = result.getOrElse(() => throw Exception());

    final printResult = await printerReceiveUseCase.call(
      success.nsuOperacao.toString(),
    );

    if (printResult.isLeft()) {
      final failure = printResult.swap().getOrElse(() => throw Exception());
      emitter(PaymentsStateError(error: failure.message));
      return;
    }

    final receiveModel = printResult.getOrElse(() => throw Exception());

    await GertecService.printComprovanteOperacao(receiveModel);

    emitter(PaymentsStateSuccess());
  }

  void _setPaymentTerm(
    PaymentsEventTerm event,
    Emitter<PaymentsState> emitter,
  ) {
    emitter(PaymentsStateTerm());
  }
}
