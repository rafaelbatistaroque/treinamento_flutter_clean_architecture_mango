import "package:mocktail/mocktail.dart";
import "package:test/test.dart";

import "../../../lib/validation/contracts/contracts.dart";
import '../../../lib/validation/validators/validators.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;

  void mockValidation(FieldValidationSpy validation, String? value, String? error) {
    when(() => validation.validate(value ?? any())).thenReturn(error);
  }

  void mockField(FieldValidationSpy validation, String field) {
    when(() => validation.field).thenReturn(field);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    validation2 = FieldValidationSpy();
    sut = ValidationComposite([validation1, validation2]);
    mockField(validation1, "other_field");
    mockValidation(validation1, null, null);
    mockField(validation2, "any_field");
    mockValidation(validation2, null, "");
  });

  test("Should return null if all validations returns null or empty", () {
    final error = sut.validate(field: "any_field", value: "any_value");

    expect(error, "");
  });

  test("Should return the first error", () {
    mockValidation(validation1, null, "erro_1");
    mockValidation(validation2, null, "erro_2");

    final error = sut.validate(field: "other_field", value: "any_value");

    expect(error, "erro_1");
  });

  test("Should return the first error of de field", () {
    mockValidation(validation1, null, "erro_1");
    mockValidation(validation2, null, "erro_2");

    final error = sut.validate(field: "any_field", value: "any_value");

    expect(error, "erro_2");
  });
}
