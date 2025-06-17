import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';
import 'package:zeeppay/shared/models/sell_model.dart';
import 'package:zeeppay/shared/service/encript_service.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc() : super(PaymentsStateInitial()) {
    on<PaymentsEventGetPassword>(_getPassword);
    on<PaymentsEventSetInicialState>(_setInitialState);
    on<PaymentsEventPutValueState>(_setPutValueState);
    on<PaymentsEventPutCardState>(_setPutCardState);
  }

  SellModel? _sellModel;
  SellModel? get getSellModel => _sellModel;

  void example() async {
    EncriptService.encrypt3DES('TESTE GUILHERME', '123456789012345678901234');
  }

  set setSellModel(SellModel? sellModel) {
    _sellModel = sellModel;
  }

  void _setInitialState(PaymentsEventSetInicialState event, Emitter emitter) {
    example();
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
}
