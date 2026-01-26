import 'package:dartz/dartz.dart';
import 'package:zeeppay/features/cashier/data/models/cashier_model.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class CashierRepository {
  Future<Either<Failure, CashierModel>> openCashier(String deviceId);
  Future<Either<Failure, bool>> closeCashier(
    String deviceId,
    String cashierSessionId,
  );
  Future<Either<Failure, CashierModel?>> getCurrentSession(String deviceId);
}
