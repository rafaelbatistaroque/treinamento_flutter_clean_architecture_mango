import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import "package:test/test.dart";

import '../../../lib/business/contracts/contracts.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({required this.secureStorage});

  Future<void> saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

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
}
