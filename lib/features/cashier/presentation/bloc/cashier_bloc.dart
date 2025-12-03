import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/cashier/domain/usecases/cashier_usecase.dart';
import 'package:zeeppay/features/cashier/presentation/bloc/cashier_event.dart';
import 'package:zeeppay/features/cashier/presentation/bloc/cashier_state.dart';

class CashierBloc extends Bloc<CashierEvent, CashierState> {
  final CashierUsecase cashierUsecase;

  CashierBloc({required this.cashierUsecase}) : super(CashierStateInitial()) {
    on<CashierEventOpenCashier>(_onOpenCashier);
    on<CashierEventCloseCashier>(_onCloseCashier);
    on<CashierEventGetCurrentSession>(_onGetCurrentSession);
    on<CashierEventReset>(_onReset);
  }

  void _onOpenCashier(CashierEventOpenCashier event, Emitter<CashierState> emit) async {
    emit(CashierStateLoading());
    
    final result = await cashierUsecase.openCashier(event.deviceId);
    
    result.fold(
      (failure) => emit(CashierStateError(error: failure.message ?? 'Erro desconhecido ao abrir caixa')),
      (cashier) => emit(CashierStateSuccess(
        message: 'Caixa aberto com sucesso!',
        cashier: cashier,
      )),
    );
  }

  void _onCloseCashier(CashierEventCloseCashier event, Emitter<CashierState> emit) async {
    emit(CashierStateLoading());
    
    final result = await cashierUsecase.closeCashier(event.deviceId, event.cashierSessionId);
    
    result.fold(
      (failure) => emit(CashierStateError(error: failure.message ?? 'Erro desconhecido ao fechar caixa')),
      (success) => emit(CashierStateSuccess(
        message: success ? 'Caixa fechado com sucesso!' : 'Falha ao fechar caixa',
      )),
    );
  }

  void _onGetCurrentSession(CashierEventGetCurrentSession event, Emitter<CashierState> emit) async {
    emit(CashierStateLoading());
    
    final result = await cashierUsecase.getCurrentSession(event.deviceId);
    
    result.fold(
      (failure) => emit(CashierStateError(error: failure.message ?? 'Erro desconhecido ao buscar sessão')),
      (cashier) => emit(CashierStateCurrentSession(cashier: cashier)),
    );
  }

  void _onReset(CashierEventReset event, Emitter<CashierState> emit) {
    emit(CashierStateInitial());
  }
}