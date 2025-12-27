import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zeeppay/core/default_options.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/splash/domain/external/urls_splash.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/auth_interceptor.dart';
import 'package:zeeppay/shared/dio/login_interceptor.dart';
import 'package:zeeppay/shared/exception/api_exception.dart';
import 'package:zeeppay/shared/external/urls.dart';
import 'package:zeeppay/shared/service/log_service.dart';

class ZeeppayDio {
  static final AuthInterceptor _authInterceptor = AuthInterceptor();
  static final LoginInterceptor _loginInterceptor = LoginInterceptor();
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 90),
    ),
  );
  String? username;
  String? password;

  SettingsPosDataStore get posDataStore => SettingsPosDataStore();
  Database get database => GetIt.instance<Database>();

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
        final token = DefaultOptions.baseTokenStore?.trim();
        if (token == null || token.isEmpty) {
          throw ApiException(message: 'Token de base não configurado');
        }

        final tempDio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );
        final response = await tempDio.get(
          UrlsLogin.loginTenant,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        print(response);
        if (response.data == null || response.statusCode != 200) {
          throw ApiException(message: 'Falha ao fazer login store');
        }
        _authInterceptor.setToken(response.data['access_token']);
        // Evita duplicação de interceptors
        _dio.interceptors.removeWhere((i) => i is AuthInterceptor);
        _dio.interceptors.add(_authInterceptor);
      } else if (username != null && password != null) {
        final response = await _dio.post(
          UrlsDefault.urlLogin(posDataStore.settings!.erCardsModel.endpoint),
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
        // Evita duplicação de interceptors
        _dio.interceptors.removeWhere((i) => i is LoginInterceptor);
        _dio.interceptors.add(_loginInterceptor);
      }

      // Log da requisição GET
      await LogService.instance.logInfo(
        'HTTP',
        'GET Request',
        details: {
          'url': url,
          'queryParameters': queryParameters,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final getResponse = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );

      // Log da resposta sucesso GET
      await LogService.instance.logInfo(
        'HTTP',
        'GET Response Success',
        details: {
          'url': url,
          'statusCode': getResponse.statusCode,
          'response': getResponse.data,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return getResponse;
    } on DioException catch (e) {
      // Log do erro HTTP GET
      await LogService.instance.logError(
        'HTTP',
        'GET Request Failed - DioException',
        details: {
          'url': url,
          'statusCode': e.response?.statusCode,
          'responseData': e.response?.data,
          'message': e.message,
          'type': e.type.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      throw ApiException(
        message:
            e.response?.data['error_description'] ??
            e.message ??
            'Erro ao fazer GET',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      // Log de erro genérico GET
      await LogService.instance.logError(
        'HTTP',
        'GET Request Failed - Unexpected Error',
        details: {
          'url': url,
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      throw ApiException(message: 'Erro inesperado: ${e.toString()}');
    }
  }

  Future<Response> post({
    required String url,
    Map<String, dynamic>? data,
    bool isStoreRequest = false,
    bool isLoginRequest = false,
    String? username,
    String? password,
    String? tokenZeepay,
  }) async {
    try {
      if (isStoreRequest) {
        final token = DefaultOptions.baseTokenStore?.trim();
        if (token == null || token.isEmpty) {
          throw ApiException(message: 'Token de base não configurado');
        }

        // Usar um Dio limpo para evitar conflitos com interceptors
        final tempDio = Dio();
        final response = await tempDio.get(
          UrlsLogin.loginTenant,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        if (response.data == null || response.statusCode != 200) {
          throw ApiException(message: 'Falha ao fazer login store');
        }
        _authInterceptor.setToken(response.data['access_token']);
        _dio.interceptors.clear();
        _dio.interceptors.add(_authInterceptor);
      } else if (tokenZeepay != null) {
        _loginInterceptor.setToken(tokenZeepay);
        _dio.interceptors.clear();
        _dio.interceptors.add(_loginInterceptor);
      } else if (username != null && password != null) {
        final response = await _dio.post(
          UrlsDefault.urlLogin(posDataStore.settings!.erCardsModel.endpoint),
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
        _dio.interceptors.clear();
        _dio.interceptors.add(_loginInterceptor);
      }

      // Log da requisição
      await LogService.instance.logInfo(
        'HTTP',
        'POST Request',
        details: {
          'url': url,
          'data': data,
          'interceptors': _dio.interceptors.length,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      final postResponse = await _dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Log da resposta sucesso
      await LogService.instance.logInfo(
        'HTTP',
        'POST Response Success',
        details: {
          'url': url,
          'statusCode': postResponse.statusCode,
          'response': postResponse.data,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return postResponse;
    } on DioException catch (e) {
      // Log do erro HTTP
      await LogService.instance.logError(
        'HTTP',
        'POST Request Failed - DioException',
        details: {
          'url': url,
          'statusCode': e.response?.statusCode,
          'responseData': e.response?.data,
          'message': e.message,
          'type': e.type.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      throw ApiException(
        message:
            e.response?.data['error_description'] ??
            e.response?.data['message'] ??
            e.response?.data['strMensagem'] ??
            e.message ??
            'Erro ao fazer POST',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      // Log de erro genérico
      await LogService.instance.logError(
        'HTTP',
        'POST Request Failed - Unexpected Error',
        details: {
          'url': url,
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      throw ApiException(message: 'Erro inesperado: ${e.toString()}');
    }
  }
}
