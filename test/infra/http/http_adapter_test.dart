import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({required String url, required String method, Map? body}) async {
    final headers = {"content-type": "application/json", "accept": "application/json"};
    final jsonBody = body != null ? jsonEncode(body) : null;

    await client.post(Uri.parse(url), headers: headers, body: jsonBody);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  late ClientSpy client;
  late HttpAdapter sut;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    registerFallbackValue(Uri());
  });

  group("post", () {
    test("Should call post with correct values", () async {
      when(() => client.post(any(), headers: any(named: "headers"), body: any(named: "body"))).thenAnswer((_) async => Response("", 200));
      final body = {"any_key": "any_value"};

      await sut.request(url: url, method: "post", body: body);

      verify(() => client.post(
            Uri.parse(url),
            headers: {"content-type": "application/json", "accept": "application/json"},
            body: jsonEncode(body),
          )).called(1);
    });

    test("Should call post without body", () async {
      when(() => client.post(any(), headers: any(named: "headers"))).thenAnswer((_) async => Response("", 200));

      await sut.request(url: url, method: "post");

      verify(() => client.post(any(), headers: any(named: "headers"))).called(1);
    });
  });
}
