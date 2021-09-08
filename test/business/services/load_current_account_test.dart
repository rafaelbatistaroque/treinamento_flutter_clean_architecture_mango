import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import "package:test/test.dart";
import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/domain/entities/entities.dart';

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String token);
}

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure("token");
    return AccountEntity(token);
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFechSecureCacheStorage() => when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockFechSecureCacheStorageSucesso() => mockFechSecureCacheStorage().thenAnswer((_) async => token);

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
}
