import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zeeppay/features/home/domain/repository/home_repository.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class HomeUsecase {
  Future<Either<Failure, bool>> call(Map<String, dynamic> sell);
  Future<Either<Failure, Response>> closeCashier(
    String deviceId,
    String cashierSessionId,
  );
  Future<Either<Failure, Response>> currentSession(String deviceId);
}

class HomeUsecaseImpl implements HomeUsecase {
  final HomeRepository homeRepository;
  HomeUsecaseImpl(this.homeRepository);

  @override
  Future<Either<Failure, bool>> call(Map<String, dynamic> sell) async {
    return await homeRepository
        .call(sell)
        .then(
          (response) => response.fold(
            (failure) => Left(failure),
            (data) => Right(data.statusCode == 200),
          ),
        );
  }

  @override
  Future<Either<Failure, Response>> closeCashier(
    String deviceId,
    String cashierSessionId,
  ) async {
    return await homeRepository
        .closeCashier(deviceId, cashierSessionId)
        .then(
          (response) =>
              response.fold((failure) => Left(failure), (data) => Right(data)),
        );
  }

  @override
  Future<Either<Failure, Response>> currentSession(String deviceId) async {
    return await homeRepository
        .currentSession(deviceId)
        .then(
          (response) =>
              response.fold((failure) => Left(failure), (data) => Right(data)),
        );
  }
}
