import 'package:intl/intl.dart';

class Formatters {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}
