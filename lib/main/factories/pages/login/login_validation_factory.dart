import '../../../../main/builders/builders.dart';
import '../../../../presentation/contracts/contracts.dart';
import '../../../../validation/validators/validators.dart';
import '../../../../validation/contracts/contracts.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.init().field("email").required().email().build(),
    ...ValidationBuilder.init().field("password").required().build(),
  ];
}
