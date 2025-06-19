import 'package:dartz/dartz.dart';
import 'package:zeeppay/features/payments/domain/model/receive_model.dart';
import 'package:zeeppay/features/payments/domain/repository/printer_receive_repository.dart';
import 'package:zeeppay/shared/models/failure.dart';

abstract class PrinterReceiveUseCase {
  Future<Either<Failure, ReceiveModel>> call(String nsu);
}

class PrinterReceiveUseCaseImpl implements PrinterReceiveUseCase {
  final PrinterReceiveRepository printerReceiveRepository;

  PrinterReceiveUseCaseImpl({required this.printerReceiveRepository});

  @override
  Future<Either<Failure, ReceiveModel>> call(String nsu) async {
    final result = await printerReceiveRepository.call(nsu);

    return result.fold((failure) => Left(failure), (response) {
      if (response.statusCode == 200) {
        final receiveModel = ReceiveModel.fromJson(response.data);
        return Right(receiveModel);
      } else {
        return Left(
          Failure(
            'Erro ao obter comprovante: ${response.statusMessage ?? 'status ${response.statusCode}'}',
          ),
        );
      }
    });
  }
}
