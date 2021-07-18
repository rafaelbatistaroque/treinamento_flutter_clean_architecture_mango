import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/authentication.dart';
import '../contract/contract.dart';
import '../helpers/helpers.dart';

class AuthenticationHandler {
  final HttpClient httpClient;
  final String url;

  AuthenticationHandler({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: "post", body: AuthenticationHandlerParams.criar(params).toJson());

      return AccountEntity.fromJson(httpResponse);
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized ? DomainError.invalidCredencials : DomainError.unexpected;
    }
  }
}

class AuthenticationHandlerParams {
  final String email;
  final String password;

  AuthenticationHandlerParams({required this.email, required this.password});

  factory AuthenticationHandlerParams.criar(AuthenticationParams params) =>
      AuthenticationHandlerParams(email: params.email, password: params.secret);

  Map toJson() => {"email": email, "password": password};
}
