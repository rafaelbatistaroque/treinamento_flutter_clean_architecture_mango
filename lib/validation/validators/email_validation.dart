import '../contracts/contracts.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String? validate(String value) {
    final regex = RegExp(r"^([\d\w.!#$%&'+*-/=?^_`{|}~]+@[\d\w]+.\w+)$");
    final isValid = value.isEmpty || regex.hasMatch(value);
    return isValid ? null : "Campo inválido";
  }
}
