import 'package:dio/dio.dart';
import 'package:gitreposearcherflutter/data/client_keys_provider.dart';
import 'package:gitreposearcherflutter/data/graphql_client_provider.dart';
import 'package:gitreposearcherflutter/data/login_prefs.dart';
import 'package:gitreposearcherflutter/data/main_dio_provider.dart';
import 'package:gitreposearcherflutter/domain/check_sign_in_status_use_case.dart';
import 'package:gitreposearcherflutter/domain/get_repo_details_use_case.dart';
import 'package:gitreposearcherflutter/domain/search_repo_use_case.dart';
import 'package:gitreposearcherflutter/domain/sign_in_use_case.dart';
import 'package:gitreposearcherflutter/ui/init_page/init_block.dart';
import 'package:gitreposearcherflutter/ui/repo_info/repo_info_block.dart';
import 'package:gitreposearcherflutter/ui/repos_search/repos_search_block.dart';
import 'package:injector/injector.dart';

void registerInjections() {
  final injector = Injector.appInstance;
  // Client keys provider
  injector.registerSingleton(
      (injector) => ClientKeyProvider("packages/client_keys/client_keys.json"));
  // Data providers
  injector.registerSingleton<LoginPrefs>((injector) => LoginPrefs());
  injector.registerSingleton((injector) => MainDioProvider());
  injector.registerDependency(
      (injector) => injector.getDependency<MainDioProvider>().dio);
  injector.registerSingleton((injector) => GraphqlClientProvider());
  injector.registerDependency((injector) =>
      injector.getDependency<GraphqlClientProvider>().graphqlClient);

  // UseCases's
  injector.registerDependency<GetRepoDetailUseCase>(
      (_) => GetRepoDetailUseCase(injector.getDependency()));
  injector.registerDependency<SearchRepoUseCase>(
      (_) => SearchRepoUseCase(injector.getDependency()));
  injector.registerDependency<CheckSignInStatusUseCase>((_) =>
      CheckSignInStatusUseCase(injector.getDependency(),
          injector.getDependency(), injector.getDependency()));
  injector.registerDependency<SignInUseCase>((injector) => SignInUseCase(
      Dio(),
      injector.getDependency(),
      injector.getDependency(),
      injector.getDependency(),
      injector.getDependency()));

  // Block's
  injector.registerDependency<RepoInfoBlock>(
      (_) => RepoInfoBlock(injector.getDependency()));
  injector.registerDependency<RepoSearchBlock>(
      (_) => RepoSearchBlock(injector.getDependency()));
  injector.registerDependency<InitBlock>(
      (_) => InitBlock(injector.getDependency(), injector.getDependency()));
}
