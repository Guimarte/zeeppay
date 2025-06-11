import 'package:flutter/services.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';

class PrinterService {
  static const _channel = MethodChannel('com.example.zeeppay/printer');

  static Future<void> printReceive() async {
    try {
      await _channel.invokeMethod('printReceive');
    } on PlatformException catch (e) {
      print("Erro na impressão: ${e.message}");
    }
  }

  static Future<void> printClientProfile(ClienteModel client) async {
    final content =
        '''
===== RESUMO DO CLIENTE =====

Nome: ${client.nome}
CPF: ${client.cpf}
Nascimento: ${Formatters.formatDateTime(client.dataNascimento)}
Email: ${client.email}
Telefone: (${client.ddd1}) ${client.telefone1}

Produto: ${client.produtoDescricao}
Número do Cartão: ${client.numeroCartao}
Validade: ${Formatters.formatDateTime(client.validade)}

Limite Total: R\$ ${client.limite.toStringAsFixed(2)}
Limite Disponível: R\$ ${client.limiteDisponivelCompras.toStringAsFixed(2)}
Limite Utilizado: R\$ ${client.limiteUtilizadoCompras.toStringAsFixed(2)} (${client.limiteUtilizadoPercentual.toStringAsFixed(1)}%)

Situação: ${client.situacao}
Motivo: ${client.motivoSituacao}

Score: ${client.score}
Qtd. Compras: ${client.quantidadeCompras}
Forma de Pagamento: ${client.formaPagamento}

Próxima Fatura: ${Formatters.formatDateTime(client.dataProximaFatura)}
Última Fatura: ${Formatters.formatDateTime(client.dataUltimaFatura)}

============================
''';

    await _channel.invokeMethod('printProfile', {"content": content});
  }

  static Future<void> lerCartao() async {
    try {
      final result = await _channel.invokeMethod('readCard');
      print(result);
    } catch (e) {
      print("Erro ao ler cartão: $e");
    }
  }
}
