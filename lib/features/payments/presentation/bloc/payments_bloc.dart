import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/payments/domain/usecase/payments_usecase.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc({required this.paymentsUsecase})
    : super(PaymentsStateInitial()) {
    on<PaymentsEventGetPassword>(_getPassword);
    on<PaymentsEventSetInicialState>(_setInitialState);
    on<PaymentsEventPutValueState>(_setPutValueState);
    on<PaymentsEventPutCardState>(_setPutCardState);
    on<PaymentsEventTransact>(_transact);
  }

  final PaymentsUsecase paymentsUsecase;

  void _setInitialState(PaymentsEventSetInicialState event, Emitter emitter) {
    emitter(PaymentsStateInitial());
  }

  void _setPutCardState(PaymentsEventPutCardState event, Emitter emitter) {
    emitter(PaymentsStatePutCard());
  }

  void _getPassword(PaymentsEventGetPassword event, Emitter emitter) async {
    emitter(PaymentsStateLoading());

    await Future.delayed(Duration(seconds: 3));
    emitter(PaymentsStatePutPassword());
  }

  void _setPutValueState(PaymentsEventPutValueState event, Emitter emitter) {
    emitter(PaymentsStatePutValue());
  }

  Future<void> _transact(PaymentsEventTransact event, Emitter emitter) async {
    emitter(PaymentsStateLoading());

    final result = await paymentsUsecase.call(event.sellModel);

    result.fold(
      (failure) {
        emitter(PaymentsStateError(error: failure.message));
      },
      (success) {
        emitter(PaymentsStateSuccess());
      },
    );
  }
}
