enum DomainError { unexpected, invalidCredencials }

extension DomainErrorExtension on DomainError {
  static Map<DomainError, String> descriptions = {
    DomainError.invalidCredencials: "Credenciais Inválidas",
    DomainError.unexpected: "Erro Inesperado",
  };

  String get description => descriptions[this] ?? "";
}
