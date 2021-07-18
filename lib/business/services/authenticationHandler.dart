import '../../domain/usecases/authentication.dart';
import '../contract/contract.dart';

class AuthenticationHandler {
  final HttpClient httpClient;
  final String url;

  AuthenticationHandler({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: "post", body: AuthenticationHandlerParams.criar(params).toJson());
  }
}

class AuthenticationHandlerParams {
  final String email;
  final String password;

  AuthenticationHandlerParams({required this.email, required this.password});

  factory AuthenticationHandlerParams.criar(AuthenticationParams params) =>
      AuthenticationHandlerParams(email: params.email, password: params.secret);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
