import 'package:http/http.dart';
import '../../../../business/services/services.dart';
import '../../../../infra/http/http.dart';
import '../../../../main/factories/factories.dart';
import '../../../../presentation/presenters/presenters.dart';

StreamLoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(validation: makeLoginValidation(), authentication: _makeAuthenticationHandler());
}

GetXLoginPresenter makeGetXLoginPresenter() {
  return GetXLoginPresenter(validation: makeLoginValidation(), authentication: _makeAuthenticationHandler());
}

AuthenticationHandler _makeAuthenticationHandler() {
  return AuthenticationHandler(httpClient: _makeHttpAdapter(), url: makeApiUrl("login"));
}

HttpAdapter _makeHttpAdapter() {
  return HttpAdapter(Client());
}
