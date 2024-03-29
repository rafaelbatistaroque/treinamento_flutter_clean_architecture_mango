import '../helpers/helpers.dart';
import '../../domain/entities/entities.dart';

class AccountModel {
  final String accessToken;

  AccountModel(this.accessToken);

  factory AccountModel.fromJson(Map? json) {
    if (!json!.containsKey("accessToken")) throw HttpError.invalidData;

    return AccountModel(json["accessToken"]);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
