import 'package:dartz/dartz.dart';
import 'package:zeeppay/features/home/domain/repository/home_repository.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class HomeUsecase {
  Future<Either<Failure, bool>> call(Map<String, dynamic> sell);
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
}
