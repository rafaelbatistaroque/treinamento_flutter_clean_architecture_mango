import '../../../lib/validation/contracts/contracts.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String? validate(String value) {
    return null;
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
}
