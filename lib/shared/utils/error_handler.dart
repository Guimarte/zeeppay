import 'package:zeeppay/shared/models/failure.dart';

/// Utilitário para tratar erros da API de forma consistente
class ErrorHandler {
  
  /// Extrai mensagem de erro para exibir ao usuário
  static String getDisplayMessage(Failure failure) {
    return failure.message ?? 'Erro desconhecido';
  }
  
  /// Retorna o erro original da API (dados completos)
  static dynamic getOriginalError(Failure failure) {
    return failure.originalError;
  }
  
  /// Retorna o status code HTTP se disponível
  static int? getStatusCode(Failure failure) {
    return failure.statusCode;
  }
  
  /// Verifica se é um erro específico da API
  static bool isApiError(Failure failure) {
    return failure.originalError != null;
  }
  
  /// Extrai detalhes específicos do erro da API
  static Map<String, dynamic>? getApiErrorDetails(Failure failure) {
    if (failure.originalError is Map<String, dynamic>) {
      return failure.originalError as Map<String, dynamic>;
    }
    return null;
  }
  
  /// Verifica se o erro contém uma mensagem específica
  static bool containsErrorCode(Failure failure, String errorCode) {
    final details = getApiErrorDetails(failure);
    if (details == null) return false;
    
    return details['error'] == errorCode ||
           details['error_code'] == errorCode ||
           details['code'] == errorCode;
  }
  
  /// Exemplo de uso para tratamento específico de erros
  static String handleSpecificErrors(Failure failure) {
    final details = getApiErrorDetails(failure);
    
    if (details != null) {
      // Trata erros específicos baseado no código da API
      switch (details['error']) {
        case 'invalid_credentials':
          return 'Credenciais inválidas. Verifique usuário e senha.';
        case 'account_locked':
          return 'Conta bloqueada. Entre em contato com o suporte.';
        case 'insufficient_funds':
          return 'Saldo insuficiente para realizar a transação.';
        default:
          // Retorna a mensagem original da API se não houver tratamento específico
          return getDisplayMessage(failure);
      }
    }
    
    // Fallback para erro genérico
    return getDisplayMessage(failure);
  }
}