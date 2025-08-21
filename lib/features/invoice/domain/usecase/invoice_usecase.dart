import 'package:dartz/dartz.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/models/failure.dart';
import '../models/card_data.dart';
import '../models/invoice_response_model.dart';
import '../../presentation/pages/mixin/invoice_page_mixin.dart';

abstract class InvoiceUsecase {
  Future<Either<Failure, CardData>> readCard();
  Future<Either<Failure, bool>> stopCardReading();
  Future<Either<Failure, List<ClienteModel>>> consultarClientePorCartao({
    required String numeroCartao,
  });
  Future<Either<Failure, InvoiceResponseModel>> consultarUltimasFaturas({
    required String numeroCartao,
    required String strProduto,
  });
}

class InvoiceUsecaseImpl with InvoicePageMixin implements InvoiceUsecase {
  @override
  Future<Either<Failure, CardData>> readCard() async {
    return await super.readCard();
  }

  @override
  Future<Either<Failure, bool>> stopCardReading() async {
    return await super.stopCardReading();
  }

  @override
  Future<Either<Failure, List<ClienteModel>>> consultarClientePorCartao({
    required String numeroCartao,
  }) async {
    return await super.consultarClientePorCartao(
      numeroCartao: numeroCartao,
    );
  }

  @override
  Future<Either<Failure, InvoiceResponseModel>> consultarUltimasFaturas({
    required String numeroCartao,
    required String strProduto,
  }) async {
    return await super.consultarUltimasFaturas(
      numeroCartao: numeroCartao,
      strProduto: strProduto,
    );
  }
}