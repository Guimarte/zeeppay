import 'package:zeeppay/shared/models/sell_model.dart';

abstract class PaymentsEvent {}

class PaymentsEventGetPassword extends PaymentsEvent {}

class PaymentsEventSetInicialState extends PaymentsEvent {}

class PaymentsEventPutValueState extends PaymentsEvent {}

class PaymentsEventPutCardState extends PaymentsEvent {}

class PaymentsEventPutPaymentType extends PaymentsEvent {
  final String paymentType;

  PaymentsEventPutPaymentType({required this.paymentType});
}

class PaymentsEventGetCardNumber extends PaymentsEvent {
  final String cardNumber;

  PaymentsEventGetCardNumber({required this.cardNumber});
}

class PaymentsEventTransact extends PaymentsEvent {
  final SellModel sellModel;

  PaymentsEventTransact({required this.sellModel});
}

class PaymentsEventTerm extends PaymentsEvent {}

class PaymentsEventSetInstallment extends PaymentsEvent {
  final int installment;

  PaymentsEventSetInstallment({required this.installment});
}

class PaymentsEventErrorCard extends PaymentsEvent {
  PaymentsEventErrorCard();
}
