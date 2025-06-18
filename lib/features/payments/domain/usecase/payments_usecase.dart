import 'package:dartz/dartz.dart';
import 'package:zeeppay/features/payments/domain/repository/payments_repository.dart';
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
    final result = await paymentsRepository.call(data.toJson());
    return result.fold((failure) => Left(failure), (response) {
      final successModel = SuccessTransactModel.fromJson(response.data);
      return Right(successModel);
    });
  }
}
