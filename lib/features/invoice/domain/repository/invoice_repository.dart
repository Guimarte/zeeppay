import 'package:dartz/dartz.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';
import '../models/card_data.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, CardData>> readCard();
  Future<Either<Failure, bool>> stopCardReading();
}

class InvoiceRepositoryImpl implements InvoiceRepository {
  @override
  Future<Either<Failure, CardData>> readCard() async {
    try {
      final cardString = await GertecService.readCard();
      
      // Verifica se houve erro na leitura
      if (cardString.contains('Erro') || cardString.contains('cancelada')) {
        return Left(Failure(cardString));
      }
      
      final cardData = CardData.fromString(cardString);
      return Right(cardData);
    } catch (e) {
      return Left(Failure('Erro ao ler cartão: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> stopCardReading() async {
    try {
      await GertecService.stopReadCard();
      return const Right(true);
    } catch (e) {
      return Left(Failure('Erro ao cancelar leitura: ${e.toString()}'));
    }
  }
}