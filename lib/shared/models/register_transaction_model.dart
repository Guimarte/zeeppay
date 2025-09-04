import 'package:zeeppay/shared/models/payment_method.dart';

class RegisterTransactionModel {
  final double amount;
  final PaymentMethod paymentMethod;
  final String? cardNumber;
  final String? customerCpf;
  final String? invoiceId;

  RegisterTransactionModel({
    required this.amount,
    required this.paymentMethod,
    this.cardNumber,
    this.customerCpf,
    this.invoiceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_method': paymentMethod.value,
      if (cardNumber != null) 'card_number': cardNumber,
      if (customerCpf != null) 'customer_cpf': customerCpf,
      if (invoiceId != null) 'invoice_id': invoiceId,
    };
  }

  factory RegisterTransactionModel.fromJson(Map<String, dynamic> json) {
    return RegisterTransactionModel(
      amount: json['amount']?.toDouble() ?? 0.0,
      paymentMethod: PaymentMethod.fromValue(json['payment_method'] ?? 'CREDIT'),
      cardNumber: json['card_number'],
      customerCpf: json['customer_cpf'],
      invoiceId: json['invoice_id'],
    );
  }
}