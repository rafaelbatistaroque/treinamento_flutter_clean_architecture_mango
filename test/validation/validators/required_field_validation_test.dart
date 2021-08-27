import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;
  String? validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);
  String? validate(String value) {
    return null;
  }
}

void main() {
  test('Shold return null if value is not empty', () {
    final sut = RequiredFieldValidation("any_field");

    var error = sut.validate("any_value");

    expect(error, null);
  });
}
