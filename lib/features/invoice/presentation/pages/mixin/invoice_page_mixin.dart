import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';
import '../../../domain/external/urls_invoice.dart';
import '../../../domain/models/card_data.dart';
import '../../../domain/models/invoice_response_model.dart';

mixin InvoicePageMixin {
  final ZeeppayDio _dio = ZeeppayDio();
  final SettingsPosDataStore _posData = SettingsPosDataStore();
  Database get database => GetIt.instance<Database>();

  Future<Either<Failure, CardData>> readCard() async {
    try {
      final cardString = await GertecService.readCard();

      if (cardString.contains('Erro') || cardString.contains('cancelada')) {
        return Left(Failure(cardString));
      }

      final cardData = CardData.fromString(cardString);
      return Right(cardData);
    } catch (e) {
      return Left(Failure('Erro ao ler cartão: ${e.toString()}'));
    }
  }

  Future<Either<Failure, bool>> stopCardReading() async {
    try {
      await GertecService.stopReadCard();
      return const Right(true);
    } catch (e) {
      return Left(Failure('Erro ao cancelar leitura: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<ClienteModel>>> consultarClientePorCartao({
    required String numeroCartao,
  }) async {
    try {
      final response = await _dio.get(
        isLoginRequest: false,
        url: UrlsInvoice.getConsultarPerfil(
          _posData.settings!.erCardsModel.endpoint,
          "31871423899",
        ),
        username: database.getString("userToken"),
        password: database.getString("passwordToken"),
      );

      final clienteList = ClienteModel.fromJsonList(response.data);
      return Right(clienteList);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error_description'] ??
          e.response?.data['strMensagem'] ??
          e.message ??
          'Erro ao consultar cliente';
      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }

  Future<Either<Failure, InvoiceResponseModel>> consultarUltimasFaturas({
    required String numeroCartao,
    required String strProduto,
  }) async {
    try {
      final response = await _dio.get(
        url: UrlsInvoice.consultarUltimasFaturas(
          _posData.settings!.erCardsModel.endpoint,
        ),
        queryParameters: {
          'numeroCartao': numeroCartao,
          'strProduto': strProduto,
        },
        username: database.getString("userToken"),
        password: database.getString("passwordToken"),
      );

      final invoiceResponse = InvoiceResponseModel.fromJson(response.data);
      return Right(invoiceResponse);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error_description'] ??
          e.response?.data['strMensagem'] ??
          e.message ??
          'Erro ao consultar faturas';
      return Left(Failure(errorMessage));
    } catch (e) {
      return Left(Failure('Erro inesperado: ${e.toString()}'));
    }
  }
}
