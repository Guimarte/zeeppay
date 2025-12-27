import 'package:dio/dio.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/core/pos_data_store.dart';
import 'package:zeeppay/features/profile/domain/external/urls_profile.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/dio/dio_implementation.dart';

abstract class ProfileRepository {
  Future<List<ClienteModel>> call(String cpf);
}

class ProfileRepositoryImpl implements ProfileRepository {
  ZeeppayDio zeeppayDio = ZeeppayDio();
  SettingsPosDataStore get posData => SettingsPosDataStore();
  final database = getIt<Database>();

  ProfileRepositoryImpl();

  @override
  Future<List<ClienteModel>> call(String cpf) async {
    try {
      final response = await zeeppayDio.get(
        url:
            '${posData.settings!.erCardsModel.endpoint}${UrlsProfile.getConsultarPerfil(cpf)}',
        password: database.getString("password") ?? '',
        username: database.getString("user") ?? '',
      );

      if (response.data == null) {
        throw Exception('Resposta vazia do servidor');
      }

      return ClienteModel.fromJsonList(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Erro ao consultar perfil: ${e.response?.statusCode} - ${e.response?.data}',
        );
      }
      throw Exception('Erro de conexão ao consultar perfil: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao consultar perfil: $e');
    }
  }
}
