import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/invoice/domain/external/urls_invoice.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/exception/api_exception.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/models/register_transaction_model.dart';
import 'package:zeeppay/shared/urls/urls_shared.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, Response<dynamic>>> requestInvoice(String cpf);
  Future<Either<Failure, Response<dynamic>>> registerTransaction(
    RegisterTransactionModel transaction,
  );
}

class InvoiceRepositoryImpl implements InvoiceRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  SettingsPosDataStore get posData => SettingsPosDataStore();
  final database = getIt<Database>();

  @override
  Future<Either<Failure, Response<dynamic>>> requestInvoice(String cpf) async {
    try {
      final response = await zeeppayDio.get(
        url: UrlsInvoice.getConsultarPerfil(
          posData.settings!.erCardsModel.endpoint,
          "31871423899",
        ),

        password: database.getString("password") ?? '',
        username: database.getString("user") ?? '',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Response<dynamic>>> registerTransaction(
    RegisterTransactionModel transaction,
  ) async {
    try {
      final deviceId = posData.settings?.devices!.first.id ?? '';
      final cashierSessionId = database.getString("cashierSessionId") ?? '';
      if (cashierSessionId == '') {
        final openCash = await zeeppayDio.post(
          isStoreRequest: true,
          url: UrlsInvoice.openCash(UrlsShared.urlDefault, deviceId),
        );
      }

      final response = await zeeppayDio.post(
        url: UrlsInvoice.getPaymentInvoice(
          posData.settings!.erCardsModel.endpoint,
          deviceId,
          cashierSessionId,
        ),
        data: transaction.toJson(),
        password: database.getString("password") ?? '',
        username: database.getString("user") ?? '',
      );
      return Right(response);
    } on ApiException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }
}
