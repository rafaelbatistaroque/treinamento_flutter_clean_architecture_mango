import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes_flutter_mango/business/helpers/helpers.dart';
import 'package:enquetes_flutter_mango/domain/helpers/helpers.dart';
import 'package:enquetes_flutter_mango/domain/usecases/usecases.dart';
import 'package:enquetes_flutter_mango/business/contract/contract.dart';
import 'package:enquetes_flutter_mango/business/services/services.dart';

class HttpClientSpy extends Mock implements HttpClient {}

class MakeSUT {
  late AuthenticationHandler sut;
  final HttpClientSpy httpClient;
  final String url;
  final AuthenticationParams params;

  MakeSUT(this.httpClient, this.url, this.params) {
    this.sut = AuthenticationHandler(httpClient: httpClient, url: url);
  }
}

void main() {
  late MakeSUT make;

  setUp(() {
    make = MakeSUT(HttpClientSpy(), faker.internet.httpUrl(),
        AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password()));
  });

  test("Should call HttpClient with correct values", () async {
    await make.sut.auth(make.params);

    verify(make.httpClient
        .request(url: make.url, method: "post", body: {"email": make.params.email, "password": make.params.secret}));
  });

  test("Should throw UnexpectedError if HttpClient returns status code 400", () async {
    when(make.httpClient.request(url: anyNamed("url"), method: anyNamed("method"), body: anyNamed("body")))
        .thenThrow(HttpError.badRequest);

    final future = make.sut.auth(make.params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
