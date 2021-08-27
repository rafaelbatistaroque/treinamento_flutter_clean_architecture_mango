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
  late String password;

  mockValidationCall(String? field) => when(() => validation.validate(field: field ?? any(named: "field"), value: any(named: "value")));
  void mockValidation({String? field, String value = ""}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test("Should call Validation with correct email", () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test("Should emit email error if validate fails", () {
    mockValidation(value: "error");

    sut.emailErrorStream.listen(expectAsync1((erro) => expect(erro, "error")));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Should emit empty if validate succeeds", () {
    sut.emailErrorStream.listen(expectAsync1((erro) => expect(erro, isEmpty)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Should call Validation with correct passowrd", () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password)).called(1);
  });

  test("Should emit password error if validate fails", () {
    mockValidation(value: "error");

    sut.passwordErrorStream.listen(expectAsync1((erro) => expect(erro, "error")));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });
}
