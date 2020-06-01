import 'package:gitreposearcherflutter/data/graphql/query_repository_info.ast.g.dart'
    as QueryRepoInfo;
import 'package:gitreposearcherflutter/domain/use_case.dart';
import 'package:gitreposearcherflutter/model/repo_info_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GetRepoDetailUseCase
    extends UseCase<GetRepoDetailUseCaseParams, RepoInfoModel> {
  GraphQLClient _client;

  GetRepoDetailUseCase(this._client);

  @override
  Future<RepoInfoModel> execute([GetRepoDetailUseCaseParams params]) async {
    final options = QueryOptions(
        documentNode: QueryRepoInfo.document,
        variables: {"name": params.title, "owner": params.owner});
    final result = await _client.query(options);
    if (result.hasException) throw result.exception;
    final repository = result.data["repository"];
    return RepoInfoModel((b) => b
      ..name = repository["name"]
      ..description = repository["description"]
      ..ownerLogin = repository["owner"]["login"]
      ..starsCount = repository["stargazers"]["totalCount"]
      ..forksCount = repository["forks"]["totalCount"]
      ..pullRequestCount = repository["pullRequests"]["totalCount"]
      ..issueCount = repository["issues"]["totalCount"]
      ..readMe = (repository["object"] ?? const {})["text"]);
  }
}

class GetRepoDetailUseCaseParams {
  GetRepoDetailUseCaseParams(this.title, this.owner);

  final String title;
  final String owner;
}
