import 'package:zeeppay/features/invoice/domain/repository/invoice_repository.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';

abstract class InvoiceUsecase {
  Future<List<ClienteModel>> call(String cpf);
}

class InvoiceUsecaseImpl implements InvoiceUsecase {
  final InvoiceRepository _invoiceRepository;

  InvoiceUsecaseImpl(this._invoiceRepository);

  @override
  Future<List<ClienteModel>> call(String cpf) async {
    final response = await _invoiceRepository.call(cpf);

    return response.fold((failure) => throw Exception(failure.message), (data) {
      try {
        final List<dynamic> jsonList = data.data ?? [];
        return jsonList.map((json) => ClienteModel.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Erro ao processar dados do cliente: ${e.toString()}');
      }
    });
  }
}
