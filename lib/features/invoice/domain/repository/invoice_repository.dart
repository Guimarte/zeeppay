import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/cashier/domain/usecases/cashier_usecase.dart';
import 'package:zeeppay/features/invoice/domain/external/urls_invoice.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/exception/api_exception.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/models/register_transaction_model.dart';

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
  final cashierUsecase = getIt<CashierUsecase>();

  @override
  Future<Either<Failure, Response<dynamic>>> requestInvoice(String cpf) async {
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

  @override
  Future<Either<Failure, Response<dynamic>>> registerTransaction(
    RegisterTransactionModel transaction,
  ) async {
    try {
      final deviceId = posData.settings?.devices!.first.id ?? '';

      final cashierSessionId = await _ensureCashierIsOpen(deviceId);
      if (cashierSessionId == null) {
        return Left(Failure.fromMessage('Não foi possível abrir o caixa'));
      }

      final response = await zeeppayDio.post(
        isStoreRequest: true,
        url: UrlsInvoice.getPaymentInvoice(deviceId, cashierSessionId),
        data: transaction.toJson(),
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

  Future<String?> _ensureCashierIsOpen(String deviceId) async {
    final currentSessionResult = await cashierUsecase.getCurrentSession(
      deviceId,
    );

    return await currentSessionResult.fold(
      (failure) async {
        return await _openNewCashierSession(deviceId);
      },
      (cashier) async {
        if (cashier != null && cashier.id != null) {
          database.setString("cashierSessionId", cashier.id!);
          return cashier.id;
        } else {
          return await _openNewCashierSession(deviceId);
        }
      },
    );
  }

  Future<String?> _openNewCashierSession(String deviceId) async {
    try {
      final openResult = await cashierUsecase.openCashier(deviceId);

      return await openResult.fold(
        (failure) async {
          database.remove("cashierSessionId");
          return null;
        },
        (cashier) async {
          if (cashier.id != null) {
            database.setString("cashierSessionId", cashier.id!);

            await Future.delayed(const Duration(milliseconds: 500));

            final verificationResult = await cashierUsecase.getCurrentSession(
              deviceId,
            );

            return verificationResult.fold(
              (failure) {
                return cashier.id;
              },
              (verifiedCashier) {
                if (verifiedCashier != null && verifiedCashier.id != null) {
                  return verifiedCashier.id;
                } else {
                  return cashier.id;
                }
              },
            );
          }
          return null;
        },
      );
    } catch (e) {
      database.remove("cashierSessionId");
      return null;
    }
  }
}
