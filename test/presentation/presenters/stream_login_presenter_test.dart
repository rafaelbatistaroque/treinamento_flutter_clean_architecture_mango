import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/presentation/presenters/presenters.dart';
import '../../../lib/presentation/contracts/contracts.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

void main() {
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late StreamLoginPresenter sut;
  late String email;
  late String password;

  mockValidationCall(String? field) => when(() => validation.validate(field: field ?? any(named: "field"), value: any(named: "value")));
  mockAuthenticationCall() => when(() => authentication.auth(any()));
  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  void mockValidation({String? field, String value = ""}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    registerFallbackValue(AuthenticationParams(email: email, secret: password));
    mockValidation();
    mockAuthentication();
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

  test("Should emit password empty if validate succeeds", () {
    sut.passwordErrorStream.listen(expectAsync1((erro) => expect(erro, isEmpty)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Should emit form invalid if any filed invalid", () {
    mockValidation(field: 'email', value: "error");

    sut.emailErrorStream.listen(expectAsync1((erro) => expect(erro, "error")));
    sut.passwordErrorStream.listen(expectAsync1((erro) => expect(erro, isEmpty)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test("Should emit form valid if all fields valids", () async {
    sut.emailErrorStream.listen(expectAsync1((erro) => expect(erro, isEmpty)));
    sut.passwordErrorStream.listen(expectAsync1((erro) => expect(erro, isEmpty)));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test("Should call Authentication with correct values", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication.auth(AuthenticationParams(email: email, secret: password))).called(1);
  });

  test("Should emit correct events on Authentication success", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test("Should emit correct events on InvalidCredentialsError", () async {
    mockAuthenticationError(DomainError.invalidCredencials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((erro) => expect(erro, "Credenciais Inválidas.")));

    await sut.auth();
  });

  test("Should emit correct events on InvalidCredentialsError", () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(false));
    sut.mainErrorStream.listen(expectAsync1((erro) => expect(erro, "Algo de  errado aconteceu. Tente novamente em breve.")));

    await sut.auth();
  });
}
