import 'package:dio/dio.dart';
import 'package:gitreposearcherflutter/ui/strings.dart';

class MainDioProvider {
  final dio = Dio();
  String _token = "";

  MainDioProvider() {
    dio.options.baseUrl = kGitBaseUrl;
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options) async {
      options.headers["Authorization"] = "token $_token";
    }));
  }

  void setToken(String token) => _token = token;
}
