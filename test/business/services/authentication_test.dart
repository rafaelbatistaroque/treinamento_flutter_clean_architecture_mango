import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class AuthenticationHandler {
  final HttpClient httpClient;
  final String url;

  AuthenticationHandler({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: "post");
  }
}

abstract class HttpClient {
  Future<void>? request({required String url, required String method});
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
    await make.sut.auth();

    verify(make.httpClient.request(url: make.url, method: "post"));
  });
}
