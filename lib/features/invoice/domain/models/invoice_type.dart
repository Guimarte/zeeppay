enum InvoiceType {
  cpf,
  card,
}

extension InvoiceTypeExtension on InvoiceType {
  String get displayName {
    switch (this) {
      case InvoiceType.cpf:
        return 'CPF';
      case InvoiceType.card:
        return 'Cartão';
    }
  }
}