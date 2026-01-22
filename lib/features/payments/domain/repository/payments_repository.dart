import 'package:dio/dio.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/payments/domain/external/urls_payments.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

import 'package:dartz/dartz.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/service/log_service.dart';

abstract class PaymentsRepository {
  Future<Either<Failure, Response>> call(Map<String, dynamic> data);
}

class PaymentsRepositoryImpl implements PaymentsRepository {
  final ZeeppayDio _dio = ZeeppayDio();
  final SettingsPosDataStore _posData = SettingsPosDataStore();
  final database = getIt<Database>();

  @override
  Future<Either<Failure, Response>> call(Map<String, dynamic> data) async {
    try {
      final url = UrlsPayments.insertPayments(
        _posData.settings!.erCardsModel.endpoint,
      );
      final username = database.getString("user") ?? '';

      LogService.instance.logInfo(
        'PaymentsRepository',
        'Iniciando requisição de pagamento',
        details: {
          'url': url,
          'username': username,
          'hasPassword': (database.getString("password") ?? '').isNotEmpty,
          'paymentData': data,
        },
      );

      final response = await _dio.post(
        url: url,
        data: data,
        isLoginRequest: false,
        password: database.getString("password") ?? '',
        username: username,
      );

      LogService.instance.logInfo(
        'PaymentsRepository',
        'Resposta recebida com sucesso',
        details: {
          'statusCode': response.statusCode,
          'responseData': response.data,
        },
      );
      return Right(response);
    } on DioException catch (e) {
      LogService.instance.logError(
        'PaymentsRepository',
        'Erro DioException na requisição',
        details: {
          'statusCode': e.response?.statusCode,
          'responseData': e.response?.data,
          'message': e.message,
          'type': e.type.toString(),
        },
      );
      return Left(
        Failure.fromApiResponse(
          e.response?.data,
          statusCode: e.response?.statusCode,
          fallbackMessage: e.message ?? 'Erro de rede na requisição',
        ),
      );
    } catch (e) {
      LogService.instance.logError(
        'PaymentsRepository',
        'Erro inesperado na requisição',
        details: {'error': e.toString(), 'errorType': e.runtimeType.toString()},
      );
      return Left(Failure.fromMessage('Erro inesperado: ${e.toString()}'));
    }
  }
}
