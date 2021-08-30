import '../entities/account_entity.dart';

abstract class SavaCurrentAccount {
  Future<void> save(AccountEntity account);
}
