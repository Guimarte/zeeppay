import 'package:flutter/services.dart';
import 'package:zeeppay/features/payments/domain/model/receive_model.dart';
import 'package:zeeppay/features/profile/domain/models/cliente_model.dart';
import 'package:zeeppay/shared/formatters/formatters.dart';

class GertecService {
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

  static Future<void> printComprovanteOperacao(ReceiveModel model) async {
    final content =
        '''
========= COMPROVANTE =========

Lojista: ${model.lojista}
CNPJ: ${model.cnpj}
Fone: ${model.fone}
Endereço: ${model.endereco}

-------------------------------

Cliente: ${model.cliente}
Telefone Cliente: ${model.foneCliente}
Cartão: ${model.cartao}

-------------------------------

Tipo de Operação: ${model.tipoOperacao}
Parcelamento: ${model.tipoParcelamento == 1 ? "À Vista" : "Parcelado"}
Prazo: ${model.prazo}x
Valor Total: R\$ ${model.valor}
Prestação: R\$ ${model.prestacao}
CET Anual: ${model.cetAno}%

-------------------------------

Data: ${model.data}
Hora: ${model.hora}
NSU Terminal: ${model.nsuTerminal}
NSU Processadora: ${model.nsuProcessadora}
Autorização: ${model.autorizacao}

===============================

      *** Obrigado! ***
''';

    await _channel.invokeMethod('printProfile', {"content": content});
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
