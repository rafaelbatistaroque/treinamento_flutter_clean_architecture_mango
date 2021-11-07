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
    await loadCurrentAccount.load();
    _navigateTo.value = "/surveys";
  }
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccountSpy loadCurrentAccount;
  late GetXSplashPresenter sut;
  late String token;

  When mockLoadCurrentPage() => when(() => loadCurrentAccount.load());

  setUp(() {
    token = faker.guid.guid();
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetXSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentPage().thenAnswer((_) async => AccountEntity(token));
  });

  test("Should call LoadCurrentAccount", () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test("Should go to survey page on success", () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/surveys")));

    sut.checkAccount();
  });
}
