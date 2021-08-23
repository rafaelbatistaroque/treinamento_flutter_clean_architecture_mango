import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({required String url, required String method}) async {
    final headers = {"content-type": "application/json", "accept": "application/json"};
    await client.post(Uri.parse(url), headers: headers);
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
      when(() => client.post(any(), headers: any(named: "headers"))).thenAnswer((_) async => Response("", 200));

      await sut.request(url: url, method: "post");

      verify(() => client.post(Uri.parse(url), headers: {"content-type": "application/json", "accept": "application/json"})).called(1);
    });
  });
}
