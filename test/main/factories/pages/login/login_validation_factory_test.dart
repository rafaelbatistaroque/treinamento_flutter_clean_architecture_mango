import "package:test/test.dart";

import '../../../../../lib/main/factories/factories.dart';
import '../../../../../lib/validation/validators/validators.dart';

void main() {
  test("Should return the correct validations", () {
    final validation = makeLoginValidations();

    expect(validation, [
      RequiredFieldValidation("email"),
      EmailValidation("email"),
      RequiredFieldValidation("password"),
    ]);
  });
}
