import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/invoice/domain/external/urls_invoice.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/exception/api_exception.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class InvoicePaymentRepository {
  Future<Either<Failure, Response<dynamic>>> call(String cpf);
}

class InvoicePaymentRepositoryImpl implements InvoicePaymentRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  SettingsPosDataStore get posData => SettingsPosDataStore();
  final database = getIt<Database>();

  @override
  Future<Either<Failure, Response<dynamic>>> call(String cpf) async {
    try {
      final response = await zeeppayDio.get(
        url: UrlsInvoice.getConsultarPerfil(
          posData.settings!.erCardsModel.endpoint,
          cpf,
        ),

        password: database.getString("password") ?? '',
        username: database.getString("user") ?? '',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left(Failure.fromMessage(e.message ?? 'Erro na API'));
    } catch (e) {
      return Left(Failure.fromMessage('Erro inesperado: ${e.toString()}'));
    }
  }
}
