import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/shared/database/database.dart';

mixin TokenSetupPageMixin {
  final database = getIt<Database>();
  static const String _baseTokenKey = "base_token";

  Future<void> saveBaseToken(String token) async {
    await database.setString(_baseTokenKey, token);
  }

  String? getBaseToken() {
    return database.getString(_baseTokenKey);
  }

  bool hasBaseToken() {
    final token = getBaseToken();
    return token != null && token.isNotEmpty;
  }
}
