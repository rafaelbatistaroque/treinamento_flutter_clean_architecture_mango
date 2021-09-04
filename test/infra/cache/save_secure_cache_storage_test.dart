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

  When mockSecure() => when(() => secureStorage.write(key: any(named: "key"), value: any(named: "value")));

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    mockSecure().thenAnswer((_) async => Response("", 204));
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  test("Should call save secure with correct values", () async {
    await sut.saveSecure(key: key, value: value);

    verify(() => secureStorage.write(key: key, value: value));
  });

  test("Should throw save secure throws", () {
    mockSecure().thenThrow(Exception());

    final future = sut.saveSecure(key: key, value: value);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}
