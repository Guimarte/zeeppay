import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc() : super(PaymentsStateInitial()) {
    on<PaymentsEventGetPassword>(_getPassword);
    on<PaymentsEventSetInicialState>(_setInitialState);
  }

  void _getPassword(PaymentsEventGetPassword event, Emitter emitter) async {
    emitter(PaymentsStateLoading());
    await Future.delayed(Duration(seconds: 3));
    emitter(PaymentsStateGetPassword());
  }

  void _setInitialState(PaymentsEventSetInicialState event, Emitter emitter) {
    emitter(PaymentsStateInitial());
  }
}
