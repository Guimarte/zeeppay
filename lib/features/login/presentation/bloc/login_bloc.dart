import 'package:bloc/bloc.dart';
import 'package:zeeppay/core/injector.dart';
import 'package:zeeppay/features/login/domain/usecase/login_usecase.dart';
import 'package:zeeppay/features/login/presentation/bloc/login_event.dart';
import 'package:zeeppay/shared/bloc/common_state.dart';
import 'package:zeeppay/shared/database/database.dart';
import 'package:zeeppay/shared/utils/error_handler.dart';
import 'package:zeeppay/shared/service/log_service.dart';

class LoginBloc extends Bloc<LoginEvent, CommonState> {
  LoginBloc({required this.loginUsecase}) : super(InitialState()) {
    on<RealizeLogin>(_realizeLogin);
  }

  final LoginUsecase loginUsecase;

  _realizeLogin(RealizeLogin event, Emitter<CommonState> emitter) async {
    emitter(LoadingState());
    final result = await loginUsecase.call(event.username, event.password);
    result.fold(
      (failure) {
        final errorMessage = _handleLoginError(failure);
        emitter(FailureState(errorMessage));
      },
      (token) {
        saveCredentials(event.username, event.password, event.saveCredentials);
        return emitter(SuccessState(true));
      },
    );
  }

  String _handleLoginError(failure) {
    // Registra erro detalhado no log
    final originalError = ErrorHandler.getOriginalError(failure);
    final statusCode = ErrorHandler.getStatusCode(failure);
    
    // Log do erro original para debug
    LogService.instance.logError(
      'LoginBloc',
      'Erro no login',
      details: {
        'originalError': originalError,
        'statusCode': statusCode,
        'failureMessage': failure.message,
      },
    );
    
    // Retorna mensagens user-friendly baseadas no tipo de erro
    if (originalError is Map<String, dynamic>) {
      final errorType = originalError['error'];
      final errorDescription = originalError['error_description'];
      
      // Log detalhado do erro da API
      LogService.instance.logError(
        'LoginBloc',
        'Detalhes do erro de login da API',
        details: {
          'errorType': errorType,
          'errorDescription': errorDescription,
          'fullResponse': originalError,
        },
      );
      
      // Trata erros específicos com mensagens amigáveis
      switch (errorType) {
        case 'invalid_grant':
          return 'Usuário ou senha incorretos. Verifique suas credenciais.';
        case 'invalid_client':
          return 'Cliente não autorizado. Entre em contato com o suporte.';
        case 'unauthorized_client':
          return 'Cliente não autorizado para este tipo de acesso.';
        case 'access_denied':
          return 'Acesso negado. Verifique suas permissões.';
        default:
          // Para erros desconhecidos, usa mensagem genérica mas registra detalhes
          LogService.instance.logWarning(
            'LoginBloc',
            'Tipo de erro não mapeado: $errorType',
            details: {'originalDescription': errorDescription},
          );
          return 'Erro no login. Verifique suas credenciais e tente novamente.';
      }
    }
    
    // Trata por status code com mensagens amigáveis
    if (statusCode != null) {
      LogService.instance.logError(
        'LoginBloc',
        'Erro HTTP no login',
        details: {
          'statusCode': statusCode,
          'originalMessage': failure.message,
        },
      );
      
      switch (statusCode) {
        case 400:
          return 'Dados de login inválidos. Verifique usuário e senha.';
        case 401:
          return 'Credenciais inválidas. Usuário ou senha incorretos.';
        case 403:
          return 'Acesso negado. Conta pode estar bloqueada.';
        case 429:
          return 'Muitas tentativas de login. Aguarde alguns minutos.';
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
      'LoginBloc',
      'Erro de login sem código específico',
      details: {
        'failureMessage': failure.message,
        'failureType': failure.runtimeType.toString(),
      },
    );
    
    return 'Erro inesperado no login. Tente novamente.';
  }

  void saveCredentials(String username, String password, bool savePassword) {
    final database = getIt<Database>();
    database.setString("userToken", username);
    database.setString("passwordToken", password);
    if (savePassword) {
      database.setString("user", username);
      database.setString("password", password);
      database.setBool("saveCredentials", savePassword);
    }
  }
}
