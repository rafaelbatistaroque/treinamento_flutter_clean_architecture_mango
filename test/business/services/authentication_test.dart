import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes_flutter_mango/domain/usecases/usecases.dart';
import 'package:enquetes_flutter_mango/business/contract/contract.dart';
import 'package:enquetes_flutter_mango/business/services/services.dart';

class HttpClientSpy extends Mock implements HttpClient {}

class MakeSUT {
  late AuthenticationHandler sut;
  final HttpClientSpy httpClient;
  final String url;

  MakeSUT(this.httpClient, this.url) {
    this.sut = AuthenticationHandler(httpClient: httpClient, url: url);
  }
}

void main() {
  late MakeSUT make;

  setUp(() {
    make = MakeSUT(HttpClientSpy(), faker.internet.httpUrl());
  });

  test("Should call HttpClient with correct values", () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    await make.sut.auth(params);

    verify(make.httpClient.request(
        url: make.url,
        method: "post",
        body: {"email": params.email, "password": params.secret}));
  });
}
