import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlClientProvider {
  String _token = "";
  GraphQLClient _client;

  GraphqlClientProvider() {
    _client = GraphQLClient(
        link: Link.from([
          AuthLink(
            getToken: () async => "token $_token",
          ),
          HttpLink(uri: 'https://api.github.com/graphql'),
        ]),
        cache: InMemoryCache());
  }

  GraphQLClient get graphqlClient => _client;

  void setToken(String token) => _token = token;
}
