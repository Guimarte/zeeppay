import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_device_model.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_model.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_operator_model.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_store_model.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_summary_model.dart';
import 'package:zeeppay/features/cashier/data/models/payments_summary_model.dart';
import 'package:zeeppay/features/cashier/data/models/purchases_summary_model.dart';
import 'package:zeeppay/features/cashier/domain/repositories/cashier_repository.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/urls/urls_shared.dart';

class CashierRepositoryImpl implements CashierRepository {
  final ZeeppayDio _dio = ZeeppayDio();
  SettingsPosDataStore get posData => SettingsPosDataStore();

  @override
  Future<Either<Failure, CashierModel>> openCashier(String deviceId) async {
    try {
      final response = await _dio.post(
        url: UrlsShared.openCash(deviceId),
        data: {},
        isStoreRequest: true,
      );

      return Right(CashierModel.fromJson(response.data['data']));
    } catch (e) {
      if (e is DioException) {
        return Left(
          Failure.fromApiResponse(
            e.response?.data,
            statusCode: e.response?.statusCode,
            fallbackMessage: 'Erro ao abrir caixa: ${e.message}',
          ),
        );
      }
      return Left(Failure.fromMessage('Erro ao abrir caixa: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> closeCashier(
    String deviceId,
    String cashierSessionId,
  ) async {
    try {
      final response = await _dio.post(
        url: UrlsShared.closeCashier(deviceId, cashierSessionId),
        data: {},
      );

      return Right(response.statusCode == 200);
    } catch (e) {
      if (e is DioException) {
        return Left(
          Failure.fromApiResponse(
            e.response?.data,
            statusCode: e.response?.statusCode,
            fallbackMessage: 'Erro ao fechar caixa: ${e.message}',
          ),
        );
      }
      return Left(Failure.fromMessage('Erro ao fechar caixa: $e'));
    }
  }

  @override
  Future<Either<Failure, CashierModel?>> getCurrentSession(
    String deviceId,
  ) async {
    return Right(
      CashierModel(
        id: 'fake-cashier-001',
        status: 'ABERTO',
        store: CashierStoreModel(
          id: 'store-001',
          name: 'Loja Teste',
          document: '12.345.678/0001-90',
          address: 'Rua Teste, 123',
          phone: '(11) 98765-4321',
        ),
        device: CashierDeviceModel(
          id: 'device-001',
          name: 'POS Teste',
          serialNumber: 'SN123456789',
        ),
        operator: CashierOperatorModel(
          id: 'operator-001',
          name: 'Operador Teste',
        ),
        openAt: '2026-01-23T08:00:00',
        closedAt: null,
        summary: CashierSummaryModel(
          paymentsSummary: PaymentsSummaryModel(
            totalPaymentsAmount: 10,
            totalPaymentsByPix: 3.0,
            totalPaymentsByCreditCard: 4.0,
            totalPaymentsByDebitCard: 2.0,
            totalPaymentsByCash: 1.0,
            totalPaymentsByCheck: 0.0,
            totalPaymentsByTransfer: 0.0,
            totalPaymentsValue: 1250.00,
            paymentsValueByPix: 350.00,
            paymentsValueByCreditCard: 500.00,
            paymentsValueByDebitCard: 250.00,
            paymentsValueByCash: 150.00,
            paymentsValueByCheck: 0.0,
            paymentsValueByTransfer: 0.0,
          ),
          purchasesSummary: PurchasesSummaryModel(
            totalPurchasesAmount: 10,
            totalPurchasesValue: 1250.00,
          ),
          openDate: '2026-01-23T08:00:00',
          closeDate: null,
          durationInSeconds: 14400,
        ),
      ),
    );
    // try {
    //   final response = await _dio.get(
    //     url: UrlsShared.currentSession(deviceId),
    //     isStoreRequest: true,
    //   );

    //   final data = response.data?['data'];
    //   return Right(data != null ? CashierModel.fromJson(data) : null);
    // } catch (e) {
    //   return Left(Failure.fromMessage('Erro ao buscar sessão: $e'));
    // }
  }
}
