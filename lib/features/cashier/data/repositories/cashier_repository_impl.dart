import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_model.dart';
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

      // Mesmo com status 500, vamos tentar processar se houver dados
      if (response.data != null) {
        // Tenta diferentes estruturas de dados
        Map<String, dynamic>? cashierData;
        
        if (response.data is Map<String, dynamic>) {
          // Tenta estrutura aninhada primeiro
          if (response.data['data'] != null && response.data['data']['cashier'] != null) {
            cashierData = response.data['data']['cashier'] as Map<String, dynamic>;
          } 
          // Tenta estrutura direta
          else if (response.data['cashier'] != null) {
            cashierData = response.data['cashier'] as Map<String, dynamic>;
          }
          // Usa a resposta inteira se tiver 'id'
          else if (response.data['id'] != null) {
            cashierData = response.data as Map<String, dynamic>;
          }
        }
        
        if (cashierData != null) {
          return Right(CashierModel.fromJson(cashierData));
        }
      }
      
      // Se chegou aqui, não conseguiu extrair dados válidos
      return Left(Failure.fromMessage('Não foi possível extrair dados do caixa da resposta (Status: ${response.statusCode})'));
      
    } on DioException catch (e) {
      return Left(Failure.fromApiResponse(
        e.response?.data,
        statusCode: e.response?.statusCode,
        fallbackMessage: 'Erro de rede ao abrir caixa: ${e.message}',
      ));
    } catch (e) {
      return Left(Failure.fromMessage('Erro inesperado ao abrir caixa: ${e.toString()}'));
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
    } on DioException catch (e) {
      return Left(Failure.fromApiResponse(
        e.response?.data,
        statusCode: e.response?.statusCode,
        fallbackMessage: 'Erro de rede ao fechar caixa: ${e.message}',
      ));
    } catch (e) {
      return Left(Failure.fromMessage('Erro inesperado ao fechar caixa: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CashierModel?>> getCurrentSession(
    String deviceId,
  ) async {
    try {
      final response = await _dio.get(
        url: UrlsShared.currentSession(deviceId),
        isStoreRequest: true,
      );

      if (response.data != null && response.data['data'] != null && response.data['data']['cashier'] != null) {
        return Right(CashierModel.fromJson(response.data['data']['cashier']));
      }

      return Right(null);
    } on DioException catch (e) {
      return Left(Failure.fromApiResponse(
        e.response?.data,
        statusCode: e.response?.statusCode,
        fallbackMessage: 'Erro de rede ao buscar sessão atual: ${e.message}',
      ));
    } catch (e) {
      return Left(
        Failure.fromMessage('Erro inesperado ao buscar sessão atual: ${e.toString()}'),
      );
    }
  }
}
