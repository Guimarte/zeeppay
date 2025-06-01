import 'package:dio/dio.dart';
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
  }) {
    _dio.interceptors.add(_authInterceptor);
    return _dio.get(url!, queryParameters: queryParameters, options: options);
  }

  @override
  Future<Response> post(String url, Map<String, dynamic> data) {
    return _dio.post(url, data: data);
  }
}
