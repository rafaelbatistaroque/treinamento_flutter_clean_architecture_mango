import 'dart:convert';

import 'package:enquetes_flutter_mango/business/contract/contract.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({required String url, required String method, Map? body}) async {
    final headers = {"content-type": "application/json", "accept": "application/json"};
    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(Uri.parse(url), headers: headers, body: jsonBody);

    return jsonDecode(response.body);
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
      final body = {"any_key": "any_value"};
      when(() => client.post(any(), headers: any(named: "headers"), body: any(named: "body")))
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      await sut.request(url: url, method: "post", body: body);

      verify(() => client.post(
            Uri.parse(url),
            headers: {"content-type": "application/json", "accept": "application/json"},
            body: jsonEncode(body),
          )).called(1);
    });

    test("Should call post without body", () async {
      when(() => client.post(any(), headers: any(named: "headers"))).thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      await sut.request(url: url, method: "post");

      verify(() => client.post(any(), headers: any(named: "headers"))).called(1);
    });

    test("Should return data if post returns 200", () async {
      when(() => client.post(any(), headers: any(named: "headers"))).thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      final response = await sut.request(url: url, method: "post");

      expect(response, {"any_key": "any_value"});
    });
  });
}
