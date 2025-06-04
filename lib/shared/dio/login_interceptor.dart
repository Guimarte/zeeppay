import 'package:dio/dio.dart';

class LoginInterceptor extends Interceptor {
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
  }
}
