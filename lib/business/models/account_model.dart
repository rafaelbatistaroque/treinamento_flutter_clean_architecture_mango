import 'package:enquetes_flutter_mango/domain/entities/account_entity.dart';

class AccountModel {
  final String accessToken;

  AccountModel(this.accessToken);

  factory AccountModel.fromJson(Map? json) => AccountModel(json!["accessToken"]);

  AccountEntity toEntity() => AccountEntity(accessToken);
}
