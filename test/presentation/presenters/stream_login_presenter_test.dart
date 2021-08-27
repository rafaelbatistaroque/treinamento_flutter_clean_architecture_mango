import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/presentation/presenters/presenters.dart';
import '../../../lib/presentation/contracts/contracts.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late ValidationSpy validation;
  late StreamLoginPresenter sut;
  late String email;

  mockValidationCall(String? field) => when(() => validation.validate(field: field ?? any(named: "field"), value: any(named: "value")));
  void mockValidation({String? field, String value = ""}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test("Should call Validation with correct email", () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test("Should emit email error if validate fails", () {
    mockValidation(value: "error");

    expectLater(sut.emailErrorStream, emits("error"));

    sut.validateEmail(email);
  });
}
