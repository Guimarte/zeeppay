abstract class PaymentsEvent {}

class PaymentsEventGetPassword extends PaymentsEvent {
  String cardNumber;
  PaymentsEventGetPassword({required this.cardNumber});
}

class PaymentsEventSetInicialState extends PaymentsEvent {}

class PaymentsEventPutValueState extends PaymentsEvent {}

class PaymentsEventPutCardState extends PaymentsEvent {}
