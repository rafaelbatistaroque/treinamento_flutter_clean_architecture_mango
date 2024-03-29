import 'dart:convert';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:enquetes_flutter_mango/business/helpers/helpers.dart';
import 'package:enquetes_flutter_mango/infra/http/http.dart';

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
  group("shared", () {
    test("Should throw serverError if invalid method provider", () async {
      final future = sut.request(url: url, method: "invalid_method");

      expect(future, throwsA(HttpError.serverError));
    });
  });
  group("post", () {
    When mockRequest() => when(() => client.post(any(), headers: any(named: "headers"), body: any(named: "body")));

    void mockResponse(int statusCode, {String body = '{"any_key": "any_value"}'}) =>
        mockRequest().thenAnswer((_) async => Response(body, statusCode));

    void mockError() => mockRequest().thenThrow(Exception());

    setUp(() {
      mockResponse(200);
    });

    test("Should call post with correct values", () async {
      final body = {"any_key": "any_value"};

      await sut.request(url: url, method: "post", body: body);

      verify(() => client.post(
            Uri.parse(url),
            headers: {"content-type": "application/json", "accept": "application/json"},
            body: jsonEncode(body),
          )).called(1);
    });

    test("Should call post without body", () async {
      await sut.request(url: url, method: "post");

      verify(() => client.post(any(), headers: any(named: "headers"))).called(1);
    });

    test("Should return data if post returns 200", () async {
      final response = await sut.request(url: url, method: "post");

      expect(response, {"any_key": "any_value"});
    });

    test("Should return null if post returns 200 with no data", () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Should return null if post returns 204", () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Should return null if post returns 204 with data", () async {
      mockResponse(204);

      final response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Should return BadRequestError if post returns 400", () async {
      mockResponse(400, body: "");

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.badRequest));
    });

    test("Should return BadRequestError if post returns 400", () async {
      mockResponse(400);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.badRequest));
    });

    test("Should return unauthorizedError if post returns 401", () async {
      mockResponse(401);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.unauthorized));
    });

    test("Should return forbiddenError if post returns 403", () async {
      mockResponse(403);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.forbbiden));
    });

    test("Should return notFoundError if post returns 404", () async {
      mockResponse(404);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.forbbiden));
    });

    test("Should return ServerError if post returns 500", () async {
      mockResponse(500);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.serverError));
    });

    test("Should return ServerError if post throws", () async {
      mockError();

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
