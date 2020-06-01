import 'package:dio/dio.dart';
import 'package:gitreposearcherflutter/domain/use_case.dart';
import 'package:gitreposearcherflutter/model/repo_item_model.dart';
import 'package:gitreposearcherflutter/ui/repos_search/repos_search_block.dart';

class SearchRepoUseCase extends UseCase<String, List<RepoItemModel>> {
  final Dio _service;
  String _nextLink;

  SearchRepoUseCase(this._service);

  @override
  Future<List<RepoItemModel>> execute([String params]) async {
    final response = (params?.isNotEmpty == true)
        ? await _service
            .get("search/repositories", queryParameters: {"q": params})
        : await _service.get("repositories");
    _nextLink = _getNextLink(response.headers["link"].first);

    return _parseResponse(response.data);
  }

  Future<List<RepoItemModel>> nextPage() async {
    if (_nextLink == null) throw NoNextPage();
    final response = await _service.getUri(Uri.parse(_nextLink));
    _nextLink = _getNextLink(response.headers["link"].first);
    return _parseResponse(response.data);
  }

  String _getNextLink(String header) {
    if (header == null) return null;
    final link = header.split(",")[0].split(";")[0];
    return link.substring(1, link.length - 1);
  }

  RepoItemModel _convertFromResponse(Map item) => RepoItemModel((b) => b
    ..id = item["id"]
    ..title = item["name"]
    ..description = item["description"]
    ..owner = item["owner"]["login"]);

  List<RepoItemModel> _parseResponse(dynamic data) {
    if (data is Map) return _parseSearchRepoResponse(data);
    if (data is List) return _parseGetPublicReposResponse(data);
    throw (Exception("can't parse response"));
  }

  List<RepoItemModel> _parseSearchRepoResponse(Map response) =>
      _parseGetPublicReposResponse(response["items"] as List);

  List<RepoItemModel> _parseGetPublicReposResponse(List items) =>
      items.map((item) => _convertFromResponse(item as Map)).toList();
}
