import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../lib/business/helpers/helpers.dart';
import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/business/contracts/contracts.dart';
import '../../../lib/business/services/services.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late AuthenticationHandler sut;
  late AuthenticationParams params;
  late HttpClientSpy httpClient;
  late String url;

  mockRequest() => when(() => httpClient.request(url: any(named: "url"), method: any(named: "method"), body: any(named: "body")));
  Map mockValidData() => {"accessToken": faker.guid.guid(), "name": faker.person.name()};
  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);
  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = AuthenticationHandler(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test("Should call HttpClient with correct values", () async {
    await sut.auth(params);

    verify(() => httpClient.request(url: url, method: "post", body: {"email": params.email, "password": params.secret}));
  });

  test("Should throw UnexpectedError if HttpClient returns status code 400", () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns status code 404", () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns status code 500", () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCredencialsError if HttpClient returns status code 401", () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredencials));
  });

  test("Should return an Account if HttpClient returns status code 200", () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData["accessToken"]);
  });

  test("Should throw UnexpectedError if HttpClient returns status code 200 with invalid data", () async {
    mockHttpData({"invalid_key": "invalid_value"});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
