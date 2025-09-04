enum PaymentMethod {
  credit('CREDIT'),
  debit('DEBIT'),
  pix('PIX'),
  money('MONEY');

  const PaymentMethod(this.value);
  
  final String value;

  static PaymentMethod fromValue(String value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.value == value,
      orElse: () => PaymentMethod.credit,
    );
  }
}