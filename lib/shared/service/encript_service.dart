import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';

class EncriptService {
  static Uint8List _keyFromHex(String hexKey) {
    return Uint8List.fromList(hex.decode(hexKey));
  }

  static Uint8List _stringToUint8List(String text) {
    return Uint8List.fromList(utf8.encode(text));
  }

  static String encrypt3DES(String plainText, String hexKey) {
    final keyBytes = _keyFromHex(hexKey);
    final input = _stringToUint8List(plainText);

    if (input.length != 8) {
      throw ArgumentError(
        'Plaintext deve ter exatamente 8 bytes para DESede sem padding.',
      );
    }

    final cipher = DESedeEngine()..init(true, KeyParameter(keyBytes));

    final output = Uint8List(cipher.blockSize);
    cipher.processBlock(input, 0, output, 0);

    return hex.encode(output);
  }

  static String decrypt3DESNoPadding(String hexEncrypted, String hexKey) {
    final keyBytes = _keyFromHex(hexKey);
    final encryptedBytes = Uint8List.fromList(hex.decode(hexEncrypted));

    final cipher = DESedeEngine()..init(false, KeyParameter(keyBytes));

    final output = Uint8List(cipher.blockSize);
    cipher.processBlock(encryptedBytes, 0, output, 0);

    return utf8.decode(output);
  }
}
