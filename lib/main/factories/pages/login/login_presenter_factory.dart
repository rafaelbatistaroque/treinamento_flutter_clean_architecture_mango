import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import '../../../../business/services/services.dart';
import '../../../../infra/http/http.dart';
import '../../../../main/factories/factories.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../business/contracts/contracts.dart';
import '../../../../infra/cache/cache.dart';

StreamLoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(validation: makeLoginValidation(), authentication: _makeAuthenticationHandler());
}

GetXLoginPresenter makeGetXLoginPresenter() {
  return GetXLoginPresenter(
      validation: makeLoginValidation(), authentication: _makeAuthenticationHandler(), saveCurrentAccount: _makeSaveCurrentAccount());
}

AuthenticationHandler _makeAuthenticationHandler() {
  return AuthenticationHandler(httpClient: _makeHttpAdapter(), url: makeApiUrl("login"));
}

HttpAdapter _makeHttpAdapter() {
  return HttpAdapter(Client());
}

SaveCurrentAccount _makeSaveCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: _makeSaveSecureCacheStorage());
}

SaveSecureCacheStorage _makeSaveSecureCacheStorage() {
  return LocalStorageAdapter(secureStorage: FlutterSecureStorage());
}
