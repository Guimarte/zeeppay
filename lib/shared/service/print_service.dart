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

  static Future<void> lerCartao() async {
    try {
      final result = await _channel.invokeMethod('readCard');
      print('MODO 1');
      print(result.toString().substring(236 - 1, 254));
      print('MODO 2');
      print(result.toString().substring(130 - 1, 233));
      print('MODO 3');
      print(result.toString().substring(90 - 1, 126));
    } catch (e) {
      print("Erro ao ler cartão: $e");
    }
  }
}
