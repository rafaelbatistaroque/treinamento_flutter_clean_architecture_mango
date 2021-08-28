import 'package:test/test.dart';
import '../../../lib/validation/validators/validators.dart';

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
