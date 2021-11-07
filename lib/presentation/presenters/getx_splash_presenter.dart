import 'package:get/get.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/pages.dart';

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
