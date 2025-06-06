import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/profile/domain/external/urls_profile.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

abstract class ProfileRepository {
  Future<ClienteModel> call(String cpf);
}

class ProfileRepositoryImpl implements ProfileRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  PosDataStore get posData => PosDataStore();
  final database = getIt<Database>();

  ProfileRepositoryImpl();

  @override
  Future<ClienteModel> call(String cpf) async {
    final response = await zeeppayDio.get(
      url:
          '${posData.posData!.settings.netWork.endpoint}${UrlsProfile.getConsultarPerfil(cpf)}',

      password: database.getString("password") ?? '',
      username: database.getString("user") ?? '',
    );

    return ClienteModel.fromJson(response.data);
  }
}
