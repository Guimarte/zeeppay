import 'package:flutter/services.dart';

class PrinterService {
  static const _channel = MethodChannel('com.example.zeeppay/printer');

  static Future<void> printReceive() async {
    try {
      await _channel.invokeMethod('printReceive');
    } on PlatformException catch (e) {
      print("Erro na impressão: ${e.message}");
    }
  }
}
