import 'package:dio/dio.dart';

class StoreInterceptor extends Interceptor {
  final _request = RequestOptions();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }
}
