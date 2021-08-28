import 'package:test/test.dart';
import 'package:faker/faker.dart';

import '../../../lib/validation/contracts/contracts.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String? validate(String value) {
    final regex = RegExp(r"^([\d\w.!#$%&'+*-/=?^_`{|}~]+@[\d\w]+.\w+)$");
    final isValid = value.isEmpty || regex.hasMatch(value);
    return isValid ? null : "Campo inválido";
  }
}

void main() {
  late EmailValidation sut;
  setUp(() {
    sut = EmailValidation("any_field");
  });
  test('Should return null if email is empty', () {
    final error = sut.validate("");

    expect(error, null);
  });

  test('Should return null if email is valid', () {
    final error = sut.validate(faker.internet.email());

    expect(error, null);
  });

  test('Should return error if email is invalid', () {
    final error = sut.validate("teste.email");

    expect(error, "Campo inválido");
  });
}
