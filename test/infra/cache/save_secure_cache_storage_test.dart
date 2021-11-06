import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import "package:test/test.dart";
import '../../../lib/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late LocalStorageAdapter sut;
  late String key;
  late String value;

  When mockSecureWrite() => when(() => secureStorage.write(key: any(named: "key"), value: any(named: "value")));
  When mockSecureRead() => when(() => secureStorage.read(key: any(named: "key")));

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    mockSecureWrite().thenAnswer((_) async => Response("", 204));
    mockSecureRead().thenAnswer((_) async => "");
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group("save Secure", () {
    test("Should call save secure with correct values", () async {
      await sut.saveSecure(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test("Should throw save secure throws", () {
      mockSecureWrite().thenThrow(Exception());

      final future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group("fetch Secure", () {
    test("Should call fetch secure with correct value", () async {
      await sut.fetchSecure(key);

      verify(() => secureStorage.read(key: key)).called(1);
    });

    test("Should return correct value on success", () async {
      mockSecureRead().thenAnswer((_) async => value);

      final fetchValue = await sut.fetchSecure(key);

      expect(fetchValue, value);
    });

    test("Should throw fetch secure throws", () {
      mockSecureRead().thenThrow(Exception());

      final future = sut.fetchSecure(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
