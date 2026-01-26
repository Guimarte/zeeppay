import 'package:zeeppay/features/cashier/data/models/cashier_model.dart';

abstract class CashierState {}

class CashierStateInitial extends CashierState {}

class CashierStateLoading extends CashierState {}

class CashierStateSuccess extends CashierState {
  final CashierModel cashier;

  CashierStateSuccess({required this.cashier});
}

class CashierStateError extends CashierState {
  final String error;

  CashierStateError({required this.error});
}

class CashierStateCurrentSession extends CashierState {
  final CashierModel? cashier;

  CashierStateCurrentSession({this.cashier});
}

class CashierCloseSuccessState extends CashierState {
  final String closed;

  CashierCloseSuccessState({required this.closed});
}
