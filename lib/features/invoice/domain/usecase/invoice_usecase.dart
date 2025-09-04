import 'package:zeeppay/features/invoice/domain/repository/invoice_repository.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/models/register_transaction_model.dart';

abstract class InvoiceUsecase {
  Future<List<ClienteModel>> requestInvoice(String cpf);
  Future<Map<String, dynamic>> registerTransaction(
    RegisterTransactionModel transaction,
  );
}

class InvoiceUsecaseImpl implements InvoiceUsecase {
  final InvoiceRepository _invoiceRepository;

  InvoiceUsecaseImpl(this._invoiceRepository);

  @override
  Future<List<ClienteModel>> requestInvoice(String cpf) async {
    final response = await _invoiceRepository.requestInvoice(cpf);

    return response.fold((failure) => throw Exception(failure.message), (data) {
      try {
        final List<dynamic> jsonList = data.data ?? [];
        return jsonList.map((json) => ClienteModel.fromJson(json)).toList();
      } catch (e) {
        throw Exception('Erro ao processar dados do cliente: ${e.toString()}');
      }
    });
  }

  @override
  Future<Map<String, dynamic>> registerTransaction(
    RegisterTransactionModel transaction,
  ) async {
    final response = await _invoiceRepository.registerTransaction(transaction);

    return response.fold((failure) => throw Exception(failure.message), (data) {
      try {
        return data.data ?? {};
      } catch (e) {
        throw Exception(
          'Erro ao processar resposta da transação: ${e.toString()}',
        );
      }
    });
  }
}
