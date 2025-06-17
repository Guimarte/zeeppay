import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class EncriptService {
  static Uint8List _createUint8ListFromString(String data) {
    return Uint8List.fromList(utf8.encode(data));
  }

  static String encrypt3DES(String plainText, String key) {
    final keyBytes = _createUint8ListFromString(key);

    final input = _createUint8ListFromString(plainText);

    final cipher = PaddedBlockCipher('DESede/ECB/PKCS7')
      ..init(
        true,
        PaddedBlockCipherParameters<KeyParameter, Null>(
          KeyParameter(keyBytes),
          null,
        ),
      );

    final encrypted = cipher.process(input);
    return base64.encode(encrypted);
  }

  static String decrypt3DES(String encryptedBase64, String key) {
    final keyBytes = _createUint8ListFromString(key);
    final encryptedBytes = base64.decode(encryptedBase64);

    final cipher = PaddedBlockCipher('DESede/ECB/PKCS7')
      ..init(
        false,
        PaddedBlockCipherParameters<KeyParameter, Null>(
          KeyParameter(keyBytes),
          null,
        ),
      );

    final decrypted = cipher.process(encryptedBytes);
    return utf8.decode(decrypted);
  }
}
