import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../../../lib/domain/entities/entities.dart';
import '../../../lib/domain/usecases/usecases.dart';
import '../../../lib/ui/pages/pages.dart';

class GetXSplashPresenter implements SplashPresenter {
  var _navigateTo = RxString("");
  final LoadCurrentAccount loadCurrentAccount;

  GetXSplashPresenter({required this.loadCurrentAccount});

  Stream<String> get navigateToStream => _navigateTo.stream;

  Future<void> checkAccount() async {
    try {
      var account = await loadCurrentAccount.load();
      _navigateTo.value = account.token.isEmpty ? "/login" : "/surveys";
    } catch (e) {
      _navigateTo.value = "/login";
    }
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetXSplashPresenter sut;

  When mockLoadCurrentPage() => when(() => loadCurrentAccount.load());

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetXSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentPage().thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  });

  test("Should call LoadCurrentAccount", () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test("Should go to survey page on success", () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/surveys")));

    sut.checkAccount();
  });

  test("Should go to login page on null result", () async {
    mockLoadCurrentPage().thenAnswer((_) async => AccountEntity(""));

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/login")));

    sut.checkAccount();
  });

  test("Should go to login page on error", () async {
    mockLoadCurrentPage().thenThrow(Exception());

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/login")));

    sut.checkAccount();
  });
}
