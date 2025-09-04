import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/shared/database/database.dart';

class DefaultOptions {
  static const keyEncript = String.fromEnvironment('KEY_ENCRIPT');
  
  static String? get baseTokenStore {
    try {
      final database = getIt<Database>();
      return database.getString("base_token");
    } catch (e) {
      return null;
    }
  }
  
  static bool get hasBaseToken {
    final token = baseTokenStore;
    return token != null && token.isNotEmpty;
  }
}
