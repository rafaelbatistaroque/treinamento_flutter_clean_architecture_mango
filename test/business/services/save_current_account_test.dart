import 'package:enquetes_flutter_mango/domain/entities/entities.dart';
import 'package:enquetes_flutter_mango/domain/helpers/helpers.dart';
import 'package:enquetes_flutter_mango/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import "package:test/test.dart";

class LocalSaveCurrentAccount implements SavaCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.saveSecure(key: "token", value: account.token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({required String key, required String value});
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  test("Should call SaveSecureCacheStorage with correct values", () async {
    final saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    when(() => saveSecureCacheStorage.saveSecure(key: any(named: "key"), value: any(named: "value")))
        .thenAnswer((_) async => Response("", HttpStatus.noContent));

    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final account = AccountEntity(faker.guid.guid());

    await sut.save(account);

    verify(() => saveSecureCacheStorage.saveSecure(key: "token", value: account.token));
  });

  test("Should throw UnespectedError if SaveSecureCacheStorage throws", () async {
    final saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    when(() => saveSecureCacheStorage.saveSecure(key: any(named: "key"), value: any(named: "value"))).thenThrow(Exception());

    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    final account = AccountEntity(faker.guid.guid());

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
