import 'package:bloc/bloc.dart';
import 'package:zeeppay/features/payments/domain/usecase/payments_usecase.dart';
import 'package:zeeppay/features/payments/domain/usecase/printer_receive_usecase.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_event.dart';
import 'package:zeeppay/features/payments/presentation/bloc/payments_state.dart';
import 'package:zeeppay/shared/service/gertec_service.dart';
import 'package:zeeppay/shared/utils/error_handler.dart';
import 'package:zeeppay/shared/service/log_service.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc({
    required this.paymentsUsecase,
    required this.printerReceiveUseCase,
  }) : super(PaymentsStateInitial()) {
    on<PaymentsEventGetPassword>(_getPassword);
    on<PaymentsEventSetInicialState>(_setInitialState);
    on<PaymentsEventPutValueState>(_setPutValueState);
    on<PaymentsEventPutCardState>(_setPutCardState);
    on<PaymentsEventTransact>(_transact);
    on<PaymentsEventTerm>(_setPaymentTerm);
    on<PaymentsEventErrorCard>(_setPutCardErrorState);
  }

  final PaymentsUsecase paymentsUsecase;
  final PrinterReceiveUseCase printerReceiveUseCase;

  void _setInitialState(PaymentsEventSetInicialState event, Emitter emitter) {
    emitter(PaymentsStateInitial());
  }

  void _setPutCardState(PaymentsEventPutCardState event, Emitter emitter) {
    emitter(PaymentsStatePutCard());
  }

  void _getPassword(PaymentsEventGetPassword event, Emitter emitter) async {
    emitter(PaymentsStatePutPassword());
  }

  void _setPutValueState(PaymentsEventPutValueState event, Emitter emitter) {
    emitter(PaymentsStatePutValue());
  }

  void _setPutCardErrorState(PaymentsEventErrorCard event, Emitter emitter) {
    emitter(PaymentsStateError());
    emitter(PaymentsStatePutValue());
  }

  Future<void> _transact(PaymentsEventTransact event, Emitter emitter) async {
    emitter(PaymentsStateLoading());

    final result = await paymentsUsecase.call(event.sellModel);

    if (result.isLeft()) {
      final failure = result.swap().getOrElse(() => throw Exception());
      final errorMessage = _handleTransactionError(failure);
      emitter(PaymentsStateError(error: errorMessage));
      return;
    }

    final success = result.getOrElse(() => throw Exception());

    final printResult = await printerReceiveUseCase.call(
      success.nsuOperacao.toString(),
    );

    if (printResult.isLeft()) {
      final failure = printResult.swap().getOrElse(() => throw Exception());
      emitter(PaymentsStateError(error: failure.message));
      return;
    }

    final receiveModel = printResult.getOrElse(() => throw Exception());

    await GertecService.printReceive(receiveModel, false);

    emitter(PaymentsStateSuccess());
  }

  String _handleTransactionError(failure) {
    // Registra erro detalhado no log
    final originalError = ErrorHandler.getOriginalError(failure);
    final statusCode = ErrorHandler.getStatusCode(failure);
    
    // Log do erro original para debug
    LogService.instance.logError(
      'PaymentsBloc',
      'Erro na transação',
      details: {
        'originalError': originalError,
        'statusCode': statusCode,
        'failureMessage': failure.message,
      },
    );
    
    // Retorna mensagens user-friendly baseadas no tipo de erro
    if (originalError is Map<String, dynamic>) {
      final errorCode = originalError['codigo_erro'] ?? originalError['error'] ?? originalError['errorCode'];
      final errorMessage = originalError['mensagem_erro'] ?? originalError['message'] ?? originalError['error_description'];
      
      // Log detalhado do erro da API
      LogService.instance.logError(
        'PaymentsBloc',
        'Detalhes do erro da API',
        details: {
          'errorCode': errorCode,
          'errorMessage': errorMessage,
          'fullResponse': originalError,
        },
      );
      
      // Trata erros específicos com mensagens amigáveis
      switch (errorCode?.toString()) {
        case '001':
        case 'INVALID_PIN':
        case 'WRONG_PASSWORD':
        case 'invalid_pin':
          return 'Senha incorreta. Digite novamente a senha do cartão.';
        case '002':
        case 'CARD_BLOCKED':
        case 'card_blocked':
          return 'Cartão bloqueado. Entre em contato com seu banco.';
        case '003':
        case 'INSUFFICIENT_FUNDS':
        case 'insufficient_funds':
          return 'Saldo insuficiente. Verifique o saldo disponível.';
        case '004':
        case 'EXPIRED_CARD':
        case 'expired_card':
          return 'Cartão vencido. Utilize um cartão válido.';
        case '005':
        case 'TRANSACTION_DENIED':
        case 'transaction_denied':
          return 'Transação negada pelo banco. Tente novamente.';
        case 'connection_timeout':
        case 'timeout':
          return 'Timeout na conexão. Verifique a conexão e tente novamente.';
        case 'network_error':
          return 'Erro de conexão. Verifique sua internet.';
        default:
          // Para erros desconhecidos, usa mensagem genérica mas registra detalhes
          LogService.instance.logWarning(
            'PaymentsBloc',
            'Código de erro não mapeado: $errorCode',
            details: {'originalMessage': errorMessage},
          );
          return 'Erro na transação. Tente novamente em alguns instantes.';
      }
    }
    
    // Trata por status code com mensagens amigáveis
    if (statusCode != null) {
      LogService.instance.logError(
        'PaymentsBloc',
        'Erro HTTP na transação',
        details: {
          'statusCode': statusCode,
          'originalMessage': failure.message,
        },
      );
      
      switch (statusCode) {
        case 400:
          return 'Dados inválidos. Verifique o valor e tente novamente.';
        case 401:
          return 'Senha incorreta. Digite novamente a senha do cartão.';
        case 403:
          return 'Transação não permitida. Verifique com seu banco.';
        case 408:
          return 'Timeout na transação. Tente novamente.';
        case 422:
          return 'Valor inválido. Verifique o valor informado.';
        case 500:
        case 502:
        case 503:
          return 'Serviço temporariamente indisponível. Tente novamente.';
        case 504:
          return 'Timeout no servidor. Tente novamente em alguns instantes.';
        default:
          return 'Erro na comunicação. Tente novamente.';
      }
    }
    
    // Fallback para erro genérico
    LogService.instance.logError(
      'PaymentsBloc',
      'Erro sem código específico',
      details: {
        'failureMessage': failure.message,
        'failureType': failure.runtimeType.toString(),
      },
    );
    
    return 'Erro inesperado. Tente novamente em alguns instantes.';
  }

  void _setPaymentTerm(
    PaymentsEventTerm event,
    Emitter<PaymentsState> emitter,
  ) {
    emitter(PaymentsStateTerm());
  }
}
