import 'package:test/test.dart';
import 'package:faker/faker.dart';

import '../../../lib/validation/validators/validators.dart';

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
