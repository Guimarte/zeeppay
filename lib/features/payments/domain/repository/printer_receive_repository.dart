import 'package:dio/dio.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/payments/domain/external/urls_payments.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

import 'package:dartz/dartz.dart';
import 'package:zeeppay/shared/exception/api_exception.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class PrinterReceiveRepository {
  Future<Either<Failure, Response<dynamic>>> call(String nsu);
}

class PrinterReceiveRepositoryImpl implements PrinterReceiveRepository {
  final ZeeppayDio zeeppayDio = ZeeppayDio();
  SettingsPosDataStore get posData => SettingsPosDataStore();

  @override
  Future<Either<Failure, Response>> call(String nsu) async {
    try {
      final response = await zeeppayDio.get(
        url: UrlsPayments.getReceive(
          posData.settings!.erCardsModel.endpoint,
          nsu,
        ),
        isLoginRequest: false,
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left(Failure.fromMessage(e.message ?? 'Erro na API'));
    } catch (e) {
      return Left(Failure.fromMessage('Erro inesperado: ${e.toString()}'));
    }
  }
}
