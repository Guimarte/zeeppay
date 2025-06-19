import 'package:dio/dio.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/payments/domain/external/urls_payments.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

import 'package:dartz/dartz.dart';
import 'package:zeeppay/shared/exception/api_exception.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class PaymentsRepository {
  Future<Either<Failure, Response>> call(Map<String, dynamic> data);
}

class PaymentsRepositoryImpl implements PaymentsRepository {
  final ZeeppayDio _dio = ZeeppayDio();
  final SettingsPosDataStore _posData = SettingsPosDataStore();

  @override
  Future<Either<Failure, Response>> call(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        url: UrlsPayments.insertPayments(
          _posData.settings!.erCardsModel.endpoint,
        ),
        data: data,
        isLoginRequest: false,
      );

      return Right(response);
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
