class Failure {
  final String? message;
  final dynamic originalError;
  final int? statusCode;
  
  Failure(this.message, {this.originalError, this.statusCode});
  
  // Construtor para manter compatibilidade com código existente
  factory Failure.fromMessage(String message) => Failure(message);
  
  // Construtor para preservar erro original da API
  factory Failure.fromApiResponse(dynamic responseData, {int? statusCode, String? fallbackMessage}) {
    return Failure(
      fallbackMessage ?? _extractErrorMessage(responseData),
      originalError: responseData,
      statusCode: statusCode,
    );
  }
  
  // Extrai mensagem do erro da resposta da API
  static String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    
    if (data is Map<String, dynamic>) {
      // Tenta diferentes campos comuns de erro
      return data['error_description'] ??
             data['strMensagem'] ??
             data['message'] ??
             data['error'] ??
             data['msg'];
    }
    
    if (data is String) return data;
    
    return null;
  }
  
  @override
  String toString() => message ?? 'Erro desconhecido';
}
