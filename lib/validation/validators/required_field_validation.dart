import '../contracts/contracts.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  String? validate(String value) {
    return value.isEmpty ? "Campo Obrigatório" : null;
  }
}
