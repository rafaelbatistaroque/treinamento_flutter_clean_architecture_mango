import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import "package:test/test.dart";
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/helpers/helpers.dart';
import '../../../lib/business/services/services.dart';
import '../../../lib/business/contracts/contracts.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFechSecureCacheStorage() => when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockFechSecureCacheStorageSucesso() => mockFechSecureCacheStorage().thenAnswer((_) async => token);
  void mockFechSecureCacheStorageError() => mockFechSecureCacheStorage().thenThrow(Exception());

  setUp(() {
    token = faker.guid.guid();
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    mockFechSecureCacheStorageSucesso();
  });

  test("Should call FetchSecureCacheStorage with correct values", () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure("token")).called(1);
  });

  test("Should return an AccountEntity", () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test("Should throw UnexpectedError if FetchSecureCacheStorage throws", () async {
    mockFechSecureCacheStorageError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
