import 'package:dio/dio.dart';
import 'package:zeeppay/core/default_options.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/dio/auth_inteceptor.dart';
import 'package:zeeppay/shared/dio/login_interceptor.dart';
import 'package:zeeppay/shared/exception/api_exception.dart';
import 'package:zeeppay/shared/external/urls.dart';

class ZeeppayDio {
  static final AuthInterceptor _authInterceptor = AuthInterceptor();
  static final LoginInterceptor _loginInterceptor = LoginInterceptor();
  static final Dio _dio = Dio();

  PosDataStore get posDataStore => PosDataStore();

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool isStoreRequest = false,
    bool isLoginRequest = false,
    String? username,
    String? password,
  }) async {
    try {
      if (isStoreRequest) {
        final token = DefaultOptions.baseTokenStore;
        final response = await _dio.get(
          UrlsLogin.loginTenant,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        if (response.data == null || response.statusCode != 200) {
          throw ApiException(message: 'Falha ao fazer login store');
        }
        _authInterceptor.setToken(response.data['access_token']);
        _dio.interceptors.add(_authInterceptor);
      } else if (username != null && password != null) {
        final response = await _dio.post(
          UrlsDefault.urlLogin(posDataStore.posData!.settings.netWork.endpoint),
          options: Options(
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          ),
          data: {
            'grant_type': 'password',
            'username': username,
            'password': password,
          },
        );
        if (isLoginRequest) return response;
        _loginInterceptor.setToken(response.data['access_token']);
        _dio.interceptors.add(_loginInterceptor);
      }

      return await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException(
        message:
            e.response?.data['error_description'] ??
            e.message ??
            'Erro ao fazer GET',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Erro inesperado: ${e.toString()}');
    }
  }

  Future<Response> post({
    required String url,
    required Map<String, dynamic> data,
    bool isLoginRequest = false,
  }) async {
    try {
      final response = await _dio.post(
        UrlsDefault.urlLogin(posDataStore.posData!.settings.netWork.endpoint),
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: data,
      );

      if (isLoginRequest) {
        return response;
      }

      _loginInterceptor.setToken(response.data['access_token']);
      _dio.interceptors.add(_loginInterceptor);

      return await _dio.post(url, data: data);
    } on DioException catch (e) {
      throw ApiException(
        message:
            e.response?.data['error_description'] ??
            e.message ??
            'Erro ao fazer POST',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiException(message: 'Erro inesperado: ${e.toString()}');
    }
  }
}
