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

void main() {
  test("Should call HttpClient with correct values", () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = AuthenticationHandler(httpClient: httpClient, url: url);

    await sut.auth();

    verify(httpClient.request(url: url, method: "post"));
  });
}
