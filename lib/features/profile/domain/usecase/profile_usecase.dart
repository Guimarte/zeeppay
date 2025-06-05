import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/features/profile/domain/repository/profile_repository.dart';

abstract class ProfileUsecase {
  Future<ClienteModel> call();
}

class ProfileUsecaseImpl implements ProfileUsecase {
  final ProfileRepository _profileRepository;

  ProfileUsecaseImpl(this._profileRepository);

  @override
  Future<ClienteModel> call() async {
    return await _profileRepository.call();
  }
}
