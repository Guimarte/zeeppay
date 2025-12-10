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

      print(response);

      final token = response.data['access_token'];

      if (token == null || token is! String) {
        return Left(
          Failure.fromMessage('Token de acesso não encontrado ou inválido'),
        );
      }

      return Right(token);
    } on DioException catch (e) {
      return Left(
        Failure.fromApiResponse(
          e.response?.data,
          statusCode: e.response?.statusCode,
          fallbackMessage: e.message ?? 'Erro de rede ao fazer login',
        ),
      );
    } catch (e) {
      return Left(Failure.fromMessage('Erro inesperado: ${e.toString()}'));
    }
  }
}
