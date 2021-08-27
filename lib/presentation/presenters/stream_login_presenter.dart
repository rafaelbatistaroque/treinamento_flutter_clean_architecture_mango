import 'dart:async';
import '../contracts/contracts.dart';

class LoginState {
  late String email = "";
  late String password = "";
  late String emailError = "";
  late String passwordError = "";

  bool get isFormValid => emailError.isEmpty && passwordError.isEmpty && email.isNotEmpty && password.isNotEmpty;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({required this.validation});

  void _update() => _controller.add(_state);

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
}
