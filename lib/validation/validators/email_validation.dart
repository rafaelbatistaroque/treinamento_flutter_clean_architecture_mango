import 'package:equatable/equatable.dart';

import '../contracts/contracts.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String field;

  List get props => [this.field];

  EmailValidation(this.field);

  String? validate(String value) {
    final regex = RegExp(r"^([\d\w.!#$%&'+*-/=?^_`{|}~]+@[\d\w]+.\w+)$");
    final isValid = value.isEmpty || regex.hasMatch(value);
    return isValid ? null : "Campo inválido";
  }
}
