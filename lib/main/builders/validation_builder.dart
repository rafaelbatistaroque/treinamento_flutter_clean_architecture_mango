import '../../validation/validators/validators.dart';
import '../../validation/contracts/contracts.dart';

class ValidationBuilder {
  late String _fieldName;
  List<FieldValidation> _validations = [];

  ValidationBuilder._(this._fieldName);

  static ValidationBuilder field(String fieldName) {
    return ValidationBuilder._(fieldName);
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
