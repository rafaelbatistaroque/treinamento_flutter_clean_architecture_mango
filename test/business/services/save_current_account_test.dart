import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import "package:test/test.dart";
import '../../../lib/business/contracts/contracts.dart';
import '../../../lib/business/services/services.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/helpers.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorageSpy saveSecureCacheStorage;
  late AccountEntity account;

  When mockSaveSecure() => when(() => saveSecureCacheStorage.saveSecure(key: any(named: "key"), value: any(named: "value")));
  void mockSaveSecureSucess() {
    mockSaveSecure().thenAnswer((_) async => Response("", 204));
  }

  void mockSaveSecureFail() {
    mockSaveSecure().thenThrow(Exception());
  }

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
    mockSaveSecureSucess();
  });

  test("Should call SaveSecureCacheStorage with correct values", () async {
    await sut.save(account);

    verify(() => saveSecureCacheStorage.saveSecure(key: "token", value: account.token));
  });

  test("Should throw UnespectedError if SaveSecureCacheStorage throws", () async {
    mockSaveSecureFail();

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
