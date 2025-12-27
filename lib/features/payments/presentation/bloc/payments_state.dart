abstract class PaymentsState {}

class PaymentsStateInitial extends PaymentsState {}

class PaymentsStateLoading extends PaymentsState {}

class PaymentsStateTypePayment extends PaymentsState {}

class PaymentsStateGetCardNumber extends PaymentsState {}

class PaymentsStatePutPassword extends PaymentsState {}

class PaymentsStateEndTransaction extends PaymentsState {}

class PaymentsStatePutValue extends PaymentsState {}

class PaymentsStatePutCard extends PaymentsState {}

class PaymentsStateError extends PaymentsState {
  String? error;

  PaymentsStateError({this.error});
}

class PaymentsStateSuccess extends PaymentsState {
  String? message;

  PaymentsStateSuccess({this.message});
}

class PaymentsStateAskClientReceipt extends PaymentsState {
  final dynamic receiveModel;

  PaymentsStateAskClientReceipt({required this.receiveModel});
}

class PaymentsStateTerm extends PaymentsState {}

class PaymentsStateInstallment extends PaymentsState {}
