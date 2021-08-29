import '../../presentation/contracts/contracts.dart';
import '../contracts/contracts.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  String validate({required String field, required String value}) {
    late String error;
    for (var validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value) ?? "";
      if (error.isNotEmpty) return error;
    }

    return error;
  }
}
