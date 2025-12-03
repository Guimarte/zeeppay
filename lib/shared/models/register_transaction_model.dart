import 'package:zeeppay/shared/models/payment_method.dart';

class RegisterTransactionModel {
  final double amount;
  final PaymentMethod paymentMethod;
  final String? cardNumber;

  RegisterTransactionModel({
    required this.amount,
    required this.paymentMethod,
    this.cardNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': amount,
      'payment_method': paymentMethod.value,
      if (cardNumber != null) 'card_number': cardNumber,
    };
  }

  factory RegisterTransactionModel.fromJson(Map<String, dynamic> json) {
    return RegisterTransactionModel(
      amount: json['amount']?.toDouble() ?? 0.0,
      paymentMethod: PaymentMethod.fromValue(
        json['payment_method'] ?? 'CREDIT',
      ),
      cardNumber: json['card_number'],
    );
  }
}
