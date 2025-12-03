class CpfValidator {
  /// Valida se o CPF está no formato correto
  static bool isValid(String cpf) {
    if (cpf.isEmpty) return false;
    
    // Remove formatação
    final cleanCpf = cpf.replaceAll(RegExp(r'[^\d]'), '');
    
    // Verifica se tem 11 dígitos
    if (cleanCpf.length != 11) return false;
    
    // Verifica se não são todos dígitos iguais
    if (RegExp(r'^(\d)\1+$').hasMatch(cleanCpf)) return false;
    
    return _validateDigits(cleanCpf);
  }

  /// Valida os dígitos verificadores do CPF
  static bool _validateDigits(String cpf) {
    // Calcula primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;
    
    // Calcula segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;
    
    // Verifica se os dígitos calculados conferem
    return int.parse(cpf[9]) == firstDigit && int.parse(cpf[10]) == secondDigit;
  }

  /// Remove formatação do CPF mantendo apenas números
  static String cleanCpf(String cpf) {
    return cpf.replaceAll(RegExp(r'[^\d]'), '');
  }
}