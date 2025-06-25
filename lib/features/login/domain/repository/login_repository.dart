import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/external/urls.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class LoginRepository {
  Future<Either<Failure, String>> call(String username, String password);
}

class LoginRepositoryImpl implements LoginRepository {
  final ZeeppayDio zeeppayDio = ZeeppayDio();
  SettingsPosDataStore get posData => SettingsPosDataStore();

  @override
  Future<Either<Failure, String>> call(String username, String password) async {
    try {
      final response = await zeeppayDio.post(
        url: UrlsDefault.urlLogin(posData.settings!.erCardsModel.endpoint),
        isLoginRequest: true,
        username: username,
        password: password,
      );

      final token = response.data['access_token'];

      if (token == null || token is! String) {
        return Left(Failure('Token de acesso não encontrado ou inválido'));
      }

      return Right(token);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error_description'] ??
          e.response?.data['strMensagem'] ??
          e.response?.data['error_description'] ??
          e.message ??
          'Erro de rede ao fazer login';
      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }
}
