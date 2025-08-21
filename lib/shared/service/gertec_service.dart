import 'package:flutter/services.dart';
import 'package:zeeppay/features/payments/domain/model/receive_model.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/flavors/flavor_config.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';

class GertecService {
  static const _channel = MethodChannel('com.example.zeeppay/printer');

  static Future<void> printClientProfile(ClienteModel client) async {
    final content =
        '''
===== RESUMO DO CLIENTE =====

Nome: ${client.nome}
CPF: ${client.cpf}
Nascimento: ${Formatters.formatDateTime(client.dataNascimento, 'dd/MM/yyyy')}
Email: ${client.email}
Telefone: (${client.ddd1}) ${client.telefone1}

Produto: ${client.produtoDescricao}
Número do Cartão: ${client.numeroCartao}
Validade: ${Formatters.formatDateTime(client.validade, 'dd/MM/yyyy')}

Limite Total: R\$ ${client.limite.toStringAsFixed(2)}
Limite Disponível: R\$ ${client.limiteDisponivelCompras.toStringAsFixed(2)}
Limite Utilizado: R\$ ${client.limiteUtilizadoCompras.toStringAsFixed(2)} (${client.limiteUtilizadoPercentual.toStringAsFixed(1)}%)

Situação: ${client.situacao}
Motivo: ${client.motivoSituacao}

Score: ${client.score}
Qtd. Compras: ${client.quantidadeCompras}
Forma de Pagamento: ${client.formaPagamento}

Próxima Fatura: ${Formatters.formatDateTime(client.dataProximaFatura, 'dd/MM/yyyy')}
Última Fatura: ${Formatters.formatDateTime(client.dataUltimaFatura, 'dd/MM/yyyy')}

============================
''';

    await _channel.invokeMethod('printProfile', {"content": content});
  }

  static Future<void> printReceive(ReceiveModel model, bool isBuyer) async {
    final ByteData imageData = await rootBundle.load(
      'assets/flavors/tridicopay/tridicopay.png',
    );
    final Uint8List imageBytes = imageData.buffer.asUint8List();

    final logo = imageBytes;

    final header =
        '''
${isBuyer ? 'VIA - CLIENTE' : 'VIA - ESTABELECIMENTO'}
''';

    final storeInfo =
        '''
${model.cnpj}
${model.lojista}
${model.endereco}
''';

    final middle =
        '''
${model.data} ${model.hora}
NSU: ${model.nsuProcessadora} Aut: ${model.autorizacao}
Cartão: ${model.cartao}
${model.tipoOperacao}
Total: R\$ ${model.valor}
${model.tipoParcelamento == 1 ? '' : 'Parcelas: ${model.prazo}x de R\$${model.prestacao} '}

''';
    final footer =
        '''
TRANSACAO AUTORIZADA COM SENHA
${model.cliente}
${model.foneCliente}


''';

    await _channel.invokeMethod('printReceive', {
      "header": header,
      "middle": middle,
      "footer": footer,
      "storeInfo": storeInfo,
      "logo": logo,
    });
  }

  static Future<String> readCard() async {
    try {
      final result = await _channel.invokeMethod('readCard');
      return result.split('B').last;
    } catch (e) {
      return "Erro ao ler cartão ou operação cancelada pelo usuário.";
    }
  }

  static Future<void> stopReadCard() async {
    await _channel.invokeMethod('stopReadCard');
  }
}
