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
      print('🟡 registerTransaction INICIADO');
      final deviceId = posData.settings?.devices!.first.id ?? '';
      print('🟡 deviceId: $deviceId');

      print('🟡 Chamando _ensureCashierIsOpen');
      final cashierSessionId = await _ensureCashierIsOpen(deviceId);
      print('🟡 cashierSessionId: $cashierSessionId');

      if (cashierSessionId == null) {
        print('❌ Caixa não foi aberto - cashierSessionId é null');
        return Left(Failure.fromMessage('Não foi possível abrir o caixa'));
      }

      print('🟡 Fazendo POST para registrar transação');
      final response = await zeeppayDio.post(
        isStoreRequest: true,
        url: UrlsInvoice.getPaymentInvoice(deviceId, cashierSessionId),
        data: transaction.toJson(),
        password: database.getString("password") ?? '',
        username: database.getString("user") ?? '',
      );
      print('🟡 Resposta recebida: ${response.statusCode}');
      return Right(response);
    } on ApiException catch (e) {
      print('❌ ApiException: ${e.message}');
      return Left(Failure.fromMessage(e.message ?? 'Erro na API'));
    } catch (e) {
      print('❌ Exception: $e');
      return Left(Failure.fromMessage('Erro inesperado: ${e.toString()}'));
    }
  }

  Future<String?> _ensureCashierIsOpen(String deviceId) async {
    print('🟣 _ensureCashierIsOpen - deviceId: $deviceId');
    final currentSessionResult = await cashierUsecase.getCurrentSession(
      deviceId,
    );

    return await currentSessionResult.fold(
      (failure) async {
        print('❌ getCurrentSession FALHOU: ${failure.message}');
        print('🟣 Tentando abrir nova sessão...');
        return await _openNewCashierSession(deviceId);
      },
      (cashier) async {
        print('✅ getCurrentSession SUCESSO');
        if (cashier != null && cashier.id != null) {
          print('✅ Sessão existente encontrada: ${cashier.id}');
          database.setString("cashierSessionId", cashier.id!);
          return cashier.id;
        } else {
          print('⚠️ Cashier é null ou sem ID - abrindo nova sessão');
          return await _openNewCashierSession(deviceId);
        }
      },
    );
  }

  Future<String?> _openNewCashierSession(String deviceId) async {
    try {
      print('🔴 _openNewCashierSession - Chamando openCashier');
      final openResult = await cashierUsecase.openCashier(deviceId);

      return await openResult.fold(
        (failure) async {
          print('❌ openCashier FALHOU: ${failure.message}');
          database.remove("cashierSessionId");
          return null;
        },
        (cashier) async {
          print('✅ openCashier SUCESSO - cashier.id: ${cashier.id}');
          if (cashier.id != null) {
            database.setString("cashierSessionId", cashier.id!);

            print('🔴 Aguardando 500ms e verificando sessão...');
            await Future.delayed(const Duration(milliseconds: 500));

            final verificationResult = await cashierUsecase.getCurrentSession(
              deviceId,
            );

            return verificationResult.fold(
              (failure) {
                print('⚠️ Verificação falhou, mas retornando cashier.id: ${cashier.id}');
                return cashier.id;
              },
              (verifiedCashier) {
                if (verifiedCashier != null && verifiedCashier.id != null) {
                  print('✅ Sessão verificada: ${verifiedCashier.id}');
                  return verifiedCashier.id;
                } else {
                  print('⚠️ Verificação retornou null, usando cashier.id: ${cashier.id}');
                  return cashier.id;
                }
              },
            );
          }
          print('❌ cashier.id é NULL após openCashier');
          return null;
        },
      );
    } catch (e) {
      print('❌ EXCEPTION em _openNewCashierSession: $e');
      database.remove("cashierSessionId");
      return null;
    }
  }
}
