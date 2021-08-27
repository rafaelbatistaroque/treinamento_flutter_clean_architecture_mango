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
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation("any_field");
  });
  test('Shold return null if value is not empty', () {
    var error = sut.validate("any_value");

    expect(error, null);
  });

  test('Shold return error if value is empty', () {
    var error = sut.validate("");

    expect(error, "Campo Obrigatório");
  });
}
