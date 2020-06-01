import 'package:gitreposearcherflutter/data/graphql_client_provider.dart';
import 'package:gitreposearcherflutter/data/login_prefs.dart';
import 'package:gitreposearcherflutter/data/main_dio_provider.dart';
import 'package:gitreposearcherflutter/domain/use_case.dart';

class CheckSignInStatusUseCase extends UseCase<void, bool> {
  final LoginPrefs _loginPrefs;
  final MainDioProvider _dioProvider;
  final GraphqlClientProvider _graphProvider;

  CheckSignInStatusUseCase(this._loginPrefs, this._dioProvider, this._graphProvider);

  @override
  Future<bool> execute([void params]) async {
    final token = await _loginPrefs.getToken();
    _dioProvider.setToken(token);
    _graphProvider.setToken(token);
    return token?.isNotEmpty == true;
  }
}
