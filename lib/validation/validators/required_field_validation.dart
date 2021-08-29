import 'package:equatable/equatable.dart';

import '../contracts/contracts.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  List get props => [this.field];

  RequiredFieldValidation(this.field);

  String? validate(String value) {
    return value.isEmpty ? "Campo Obrigatório" : null;
  }
}
