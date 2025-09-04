import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/home/domain/external/home_url.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/urls/urls_shared.dart';

abstract class HomeRepository {
  Future<Either<Failure, Response<dynamic>>> call(Map<String, dynamic> sell);
  Future<Either<Failure, Response<dynamic>>> closeCashier(
    String deviceId,
    String cashierSessionId,
  );
  Future<Either<Failure, Response<dynamic>>> currentSession(String deviceId);
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
      return Left(Failure('Erro de rede: ${e.message}'));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Response>> closeCashier(
    String deviceId,
    String cashierSessionId,
  ) async {
    try {
      final response = await _dio.post(
        url: UrlsShared.closeCashier(deviceId, cashierSessionId),
        data: {},
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure('Erro de rede: ${e.message}'));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Response>> currentSession(String deviceId) async {
    try {
      final response = await _dio.get(
        url: UrlsShared.currentSession(deviceId),
        isStoreRequest: true,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(Failure('Erro de rede: ${e.message}'));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }
}
