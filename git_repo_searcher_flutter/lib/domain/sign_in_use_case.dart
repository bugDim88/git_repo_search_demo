import 'package:dio/dio.dart';
import 'package:gitreposearcherflutter/data/graphql_client_provider.dart';
import 'package:gitreposearcherflutter/data/login_prefs.dart';
import 'package:gitreposearcherflutter/data/main_dio_provider.dart';
import 'package:gitreposearcherflutter/domain/use_case.dart';
import 'package:gitreposearcherflutter/ui/strings.dart';

class SignInUseCase extends UseCase<String, bool> {
  final Dio _service;
  final LoginPrefs _loginPrefs;
  final MainDioProvider _dioProvider;
  final GraphqlClientProvider _graphProvider;
  final _url = "https://github.com/login/oauth/access_token";

  SignInUseCase(
      this._service, this._loginPrefs, this._dioProvider, this._graphProvider);

  @override
  Future<bool> execute([String params]) async {
    final response = await _service.post(_url, queryParameters: {
      "code": params,
      "client_id": kClientId,
      "client_secret": kClientSecret
    });
    final accessToken = response.data
        .toString()
        .split("&")
        .firstWhere((element) => element.contains("access_token"),
            orElse: () => null)
        ?.split("=")
        ?.last;
    if (accessToken == null) throw Exception("null token received");
    _loginPrefs.setToken(accessToken);
    _dioProvider.setToken(accessToken);
    _graphProvider.setToken(accessToken);
    return true;
  }
}
