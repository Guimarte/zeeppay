abstract class PaymentsState {}

class PaymentsStateInitial extends PaymentsState {}

class PaymentsStateLoading extends PaymentsState {}

class PaymentsStateTypePayment extends PaymentsState {}

class PaymentsStateGetCardNumber extends PaymentsState {}

class PaymentsStateGetPassword extends PaymentsState {}

class PaymentsStateEndTransaction extends PaymentsState {}

class PaymentsStateError extends PaymentsState {}
