import 'package:dio/dio.dart';
import 'package:zeeppay/core/default_options.dart';
import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/dio/token_interceptor.dart';

class ZeeppayDio {
  static final AuthInterceptor _authInterceptor = AuthInterceptor();

  static final Dio _dio = Dio();
  static AuthInterceptor get authInterceptor => _authInterceptor;

  @override
  Future<Response>? get({
    String? url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool isStoreRequest = false,
    String? username,
    String? password,
  }) async {
    if (isStoreRequest) {
      final token = DefaultOptions.baseTokenStore;
      final response = await _dio.get(
        UrlsLogin.loginTenant,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data == null || response.statusCode != 200) {
        throw Exception('Failed to login');
      }
      _authInterceptor.setToken(response.data['access_token']);
      _dio.interceptors.add(_authInterceptor);
    }

    return await _dio.get(
      url!,
      queryParameters: queryParameters,
      options: options,
    );
  }

  @override
  Future<Response> post(String url, Map<String, dynamic> data) {
    return _dio.post(url, data: data);
  }
}
