import 'dart:async';

import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../contracts/contracts.dart';

class LoginState {
  late String email = "";
  late String password = "";
  late String emailError = "";
  late String passwordError = "";
  late String mainError = "";
  late String navigateTo = "";
  late bool isLoading = false;

  bool get isFormValid => emailError.isEmpty && passwordError.isEmpty && email.isNotEmpty && password.isNotEmpty;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();
  Stream<String> get mainErrorStream => _controller.stream.map((state) => state.mainError).distinct();
  Stream<String> get navigateToStream => _controller.stream.map((state) => state.navigateTo).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();
  Stream<bool> get isLoadingStream => _controller.stream.map((state) => state.isLoading).distinct();

  StreamLoginPresenter({required this.validation, required this.authentication});

  void _update() {
    if (_controller.isClosed) return;
    _controller.add(_state);
  }

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: "email", value: email);
    _state.email = email;
    _update();
  }

  void validatePassword(String password) {
    _state.passwordError = validation.validate(field: "password", value: password);
    _state.password = password;
    _update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    } finally {
      _state.isLoading = false;
      _update();
    }
  }

  void dispose() {
    _controller.close();
  }
}
