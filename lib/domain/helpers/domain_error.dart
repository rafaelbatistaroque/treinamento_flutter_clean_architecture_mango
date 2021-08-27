enum DomainError { unexpected, invalidCredencials }

extension DomainErrorExtension on DomainError {
  static Map<DomainError, String> descriptions = {
    DomainError.invalidCredencials: "Credenciais Inválidas.",
    DomainError.unexpected: "Algo de  errado aconteceu. Tente novamente em breve.",
  };

  String get description => descriptions[this] ?? descriptions[DomainError.unexpected].toString();
}
