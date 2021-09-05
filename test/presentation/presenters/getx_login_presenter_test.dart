import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/presentation/presenters/presenters.dart';
import '../../../lib/presentation/contracts/contracts.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late ValidationSpy validation;
  late AuthenticationSpy authentication;
  late SaveCurrentAccountSpy saveCurrentAccount;
  late GetXLoginPresenter sut;
  late String email;
  late String password;
  late String token;

  mockValidationCall(String? field) => when(() => validation.validate(field: field ?? any(named: "field"), value: any(named: "value")));
  mockAuthenticationCall() => when(() => authentication.auth(any()));
  mockSaveCurrentAccountCall() => when(() => saveCurrentAccount.save(any()));
  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));
  }

  void mockSaveCurrentAccountSuccess() {
    mockSaveCurrentAccountCall().thenAnswer((_) async => Response("", 204));
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
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetXLoginPresenter(validation: validation, authentication: authentication, saveCurrentAccount: saveCurrentAccount);
    token = faker.guid.guid();
    email = faker.internet.email();
    password = faker.internet.password();
    registerFallbackValue(AuthenticationParams(email: email, secret: password));
    registerFallbackValue(AccountEntity(token));
    mockValidation();
    mockAuthentication();
    mockSaveCurrentAccountSuccess();
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

  test("Should call SaveCurrentAccount with correct value", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test("Should emit UnexpectedError if SaveCurrentAccount errors", () async {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((erro) => expect(erro, "Algo de  errado aconteceu. Tente novamente em breve.")));

    await sut.auth();
  });

  test("Should emit correct events on Authentication success", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    await sut.auth();
  });

  test("Should emit correct events on InvalidCredentialsError", () async {
    mockAuthenticationError(DomainError.invalidCredencials);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((erro) => expect(erro, "Credenciais Inválidas.")));

    await sut.auth();
  });

  test("Should emit correct events on UnexpectedError", () async {
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1((erro) => expect(erro, "Algo de  errado aconteceu. Tente novamente em breve.")));

    await sut.auth();
  });

  test("Should change page on sucess", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/surveys")));

    await sut.auth();
  });
}
