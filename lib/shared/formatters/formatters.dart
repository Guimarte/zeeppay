import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatters {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formatCurrency(double value) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return currencyFormat.format(value);
  }

  static String formatCurrencyFromCents(String cents) {
    if (cents.isEmpty) return 'R\$ 0,00';
    final int value = int.tryParse(cents) ?? 0;
    final double reais = value / 100;
    return formatCurrency(reais);
  }

  static String eraseTextField(TextEditingController field) {
    if (field.text.isNotEmpty) {
      field.text = field.text.substring(0, field.text.length - 1);
    }
    return field.text;
  }
}
