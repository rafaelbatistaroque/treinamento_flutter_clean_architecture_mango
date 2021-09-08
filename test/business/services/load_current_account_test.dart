import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import "package:test/test.dart";
import '../../../lib/domain/entities/entities.dart';

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String token);
}

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure("token");
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;

  When mockFechSecureCacheStorage() => when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockFechSecureCacheStorageSucesso() => mockFechSecureCacheStorage().thenAnswer((_) async => Response("", 204));

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    mockFechSecureCacheStorageSucesso();
  });

  test("Should call FetchSecureCacheStorage with correct values", () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetchSecure("token")).called(1);
  });
}
