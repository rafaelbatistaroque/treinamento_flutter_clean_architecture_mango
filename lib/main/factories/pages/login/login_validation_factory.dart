import '../../../../presentation/contracts/contracts.dart';
import '../../../../validation/validators/validators.dart';
import '../../../../validation/contracts/contracts.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation("email"),
    EmailValidation("email"),
    RequiredFieldValidation("password"),
  ];
}
