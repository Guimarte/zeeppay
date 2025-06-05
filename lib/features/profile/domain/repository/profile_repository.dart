import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/profile/domain/external/urls_profile.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

abstract class ProfileRepository {
  Future<ClienteModel> call();
}

class ProfileRepositoryImpl implements ProfileRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  PosDataStore get posData => PosDataStore();

  ProfileRepositoryImpl();

  @override
  Future<ClienteModel> call() async {
    return await zeeppayDio.get(
          url:
              '${posData.posData!.settings.netWork.endpoint}${UrlsProfile.getConsultarPerfil}',
        )
        as ClienteModel;
  }
}
