import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes_flutter_mango/domain/useCases/authentication.dart';

class AuthenticationHandler {
  final HttpClient httpClient;
  final String url;

  AuthenticationHandler({
    required this.httpClient,
    required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {"email": params.email, "password": params.secret};
    await httpClient.request(url: url, method: "post", body: body);
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    Map<String, dynamic> body});
}

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
    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());

    await make.sut.auth(params);

    verify(make.httpClient.request(
        url: make.url,
        method: "post",
        body: {"email": params.email, "password": params.secret}));
  });
}
