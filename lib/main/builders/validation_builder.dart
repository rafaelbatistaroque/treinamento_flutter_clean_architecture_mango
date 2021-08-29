import '../../validation/validators/validators.dart';
import '../../validation/contracts/contracts.dart';

class ValidationBuilder {
  late String _fieldName;
  List<FieldValidation> _validations = [];

  static ValidationBuilder init() {
    return ValidationBuilder();
  }

  ValidationBuilder field(String fieldName) {
    _fieldName = fieldName;
    return this;
  }

  ValidationBuilder required() {
    _validations.add(RequiredFieldValidation(_fieldName));
    return this;
  }

  ValidationBuilder email() {
    _validations.add(EmailValidation(_fieldName));
    return this;
  }

  List<FieldValidation> build() => _validations;
}
