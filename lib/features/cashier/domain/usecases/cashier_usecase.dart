import 'package:dartz/dartz.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_model.dart';
import 'package:zeeppay/features/cashier/domain/repositories/cashier_repository.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class CashierUsecase {
  Future<Either<Failure, CashierModel>> openCashier(String deviceId);
  Future<Either<Failure, bool>> closeCashier(
    String deviceId,
    String cashierSessionId,
  );
  Future<Either<Failure, CashierModel?>> getCurrentSession(String deviceId);
}

class CashierUsecaseImpl implements CashierUsecase {
  final CashierRepository _cashierRepository;

  CashierUsecaseImpl(this._cashierRepository);

  @override
  Future<Either<Failure, CashierModel>> openCashier(String deviceId) async {
    return await _cashierRepository.openCashier(deviceId);
  }

  @override
  Future<Either<Failure, bool>> closeCashier(
    String deviceId,
    String cashierSessionId,
  ) async {
    return await _cashierRepository.closeCashier(deviceId, cashierSessionId);
  }

  @override
  Future<Either<Failure, CashierModel?>> getCurrentSession(
    String deviceId,
  ) async {
    return await _cashierRepository.getCurrentSession(deviceId);
  }
}
