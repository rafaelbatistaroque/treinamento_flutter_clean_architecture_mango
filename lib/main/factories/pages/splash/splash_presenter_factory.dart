import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../business/services/services.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../business/contracts/contracts.dart';
import '../../../../infra/cache/cache.dart';

GetXSplashPresenter makeGetXSplashPresenter() {
  return GetXSplashPresenter(loadCurrentAccount: _makeLoadCurrentAccount());
}

LoadCurrentAccount _makeLoadCurrentAccount() {
  return LocalLoadCurrentAccount(fetchSecureCacheStorage: _makeFetchSecureCacheStorage());
}

FetchSecureCacheStorage _makeFetchSecureCacheStorage() {
  return LocalStorageAdapter(secureStorage: FlutterSecureStorage());
}
