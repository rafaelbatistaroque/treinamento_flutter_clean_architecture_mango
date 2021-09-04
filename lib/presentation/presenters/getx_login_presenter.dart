import 'package:get/get.dart';

import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../contracts/contracts.dart';

class GetXLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  late String _email = "";
  late String _password = "";

  final _emailError = RxString("");
  final _passwordError = RxString("");
  final _mainError = RxString("");
  final _isLoading = RxBool(false);
  final _isFormValid = false.obs;

  Stream<String> get emailErrorStream => _emailError.stream;
  Stream<String> get passwordErrorStream => _passwordError.stream;
  Stream<String> get mainErrorStream => _mainError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetXLoginPresenter({required this.validation, required this.authentication, required this.saveCurrentAccount});

  void _validateForm() {
    _isFormValid.value = _emailError.value.isEmpty && _passwordError.value.isEmpty && _email.isNotEmpty && _password.isNotEmpty;
  }

  void validateEmail(String email) {
    _emailError.value = validation.validate(field: "email", value: email);
    _email = email;
    _validateForm();
  }

  void validatePassword(String password) {
    _passwordError.value = validation.validate(field: "password", value: password);
    _password = password;
    _validateForm();
  }

  Future<void> auth() async {
    _isLoading.value = true;
    _validateForm();
    try {
      final account = await authentication.auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      _mainError.value = error.description;
    } finally {
      _isLoading.value = false;
      _validateForm();
    }
  }

  void dispose() {}
}
