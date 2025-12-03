import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/home/domain/external/home_url.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, Response<dynamic>>> call(Map<String, dynamic> sell);
}

class HomeRepositoryImpl implements HomeRepository {
  final ZeeppayDio _dio = ZeeppayDio();
  SettingsPosDataStore get posData => SettingsPosDataStore();

  @override
  Future<Either<Failure, Response>> call(Map<String, dynamic> sell) async {
    try {
      final response = await _dio.post(
        url: HomeUrl.cancelSell(posData.settings!.erCardsModel.endpoint),
        data: sell,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure.fromApiResponse(
        e.response?.data,
        statusCode: e.response?.statusCode,
        fallbackMessage: 'Erro de rede: ${e.message}',
      ));
    } catch (e) {
      return Left(Failure.fromMessage('Erro inesperado: ${e.toString()}'));
    }
  }
}
