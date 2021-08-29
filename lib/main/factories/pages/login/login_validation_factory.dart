import '../../../../main/builders/builders.dart';
import '../../../../presentation/contracts/contracts.dart';
import '../../../../validation/validators/validators.dart';
import '../../../../validation/contracts/contracts.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field("email").required().email().build(),
    ...ValidationBuilder.field("password").required().build(),
  ];
}
