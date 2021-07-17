import '../../domain/usecases/authentication.dart';
import '../contract/contract.dart';

class AuthenticationHandler {
  final HttpClient httpClient;
  final String url;

  AuthenticationHandler({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: "post", body: params.toJson());
  }
}
