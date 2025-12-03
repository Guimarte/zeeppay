import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:zeeppay/features/payments/domain/repository/payments_repository.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/models/failure.dart';
import 'package:zeeppay/shared/models/sell_model.dart';
import 'package:zeeppay/shared/models/sucess_transact_model.dart';

abstract class PaymentsUsecase {
  Future<Either<Failure, SuccessTransactModel>> call(SellModel data);
}

class PaymentsUsecaseImpl implements PaymentsUsecase {
  final PaymentsRepository paymentsRepository;

  PaymentsUsecaseImpl({required this.paymentsRepository});

  @override
  Future<Either<Failure, SuccessTransactModel>> call(SellModel data) async {
    final database = GetIt.instance<Database>();
    final result = await paymentsRepository.call(data.toJson());

    return result.fold((failure) => Left(failure), (response) {
      if (response.statusCode == 200) {
        try {
          final successModel = SuccessTransactModel.fromJson(response.data);
          database.setString('lastSale', jsonEncode(successModel.toJson()));
          return Right(successModel);
        } catch (e) {
          return Left(Failure.fromMessage('Erro ao processar resposta: ${e.toString()}'));
        }
      } else {
        return Left(
          Failure.fromMessage(
            'Erro na transação: ${response.statusMessage ?? 'status ${response.statusCode}'}',
          ),
        );
      }
    });
  }
}
