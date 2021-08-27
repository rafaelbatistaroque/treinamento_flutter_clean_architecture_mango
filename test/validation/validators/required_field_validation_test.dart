import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String? validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  String? validate(String value) {
    return value.isEmpty ? "Campo Obrigatório" : null;
  }
}

void main() {
  test('Shold return null if value is not empty', () {
    final sut = RequiredFieldValidation("any_field");

    var error = sut.validate("any_value");

    expect(error, null);
  });

  test('Shold return error if value is empty', () {
    final sut = RequiredFieldValidation("any_field");

    var error = sut.validate("");

    expect(error, "Campo Obrigatório");
  });
}
