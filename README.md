# git_repo_search_demo
**git_repo_search_demo** is demo project that shows basic 2020 approach for building 
mobile apps with native [Android](https://www.android.com/) and crossplatform 
[Flutter](https://flutter.dev/) frameworks.

Basically application by itself it is simple [GitHub](https://github.com/) repositories 
browser, but inside it is got pretty big up to date tech-stack. 
From backend application uses both [REST](https://developer.github.com/v3/) and 
[Graphql](https://developer.github.com/v4/) Git Hub API.

Repository contains from 2 projects:
* [git_repo_search_kotlin](https://github.com/bugDim88/git_repo_search_demo/tree/master/git_repo_searcher_kotlin)
 with native implementation
* [git_repo_search_flutter](https://github.com/bugDim88/git_repo_search_demo/tree/master/git_repo_searcher_flutter)
 with flutter implementation

## Tech-stack

<img src="demo.gif" width="336" align="right" hspace="20">

### Native implementation
* Tech-stack
  * [Kotlin](https://kotlinlang.org/) + [Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html) - perform async operations
  * [Kodein](https://kodein.org/Kodein-DI/) - dependency injection
  * [Retrofit](https://square.github.io/retrofit/) - for REST networking
  * [Apollo GraphQL Client](https://www.apollographql.com/docs/android/essentials/get-started/) - for GraphQL networking
  * [Markwon](https://noties.io/Markwon/) - for markdown parsing
  * [Jetpack](https://developer.android.com/jetpack)
    * [Navigation](https://developer.android.com/guide/navigation/)
    * [LiveData](https://developer.android.com/topic/libraries/architecture/livedata)
    * [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel)
 * Architecture
   * Clean Architecture
   * MVI (presentation layer)
### Flutter implementation
* Tech-stack
  * [Injector](https://pub.dev/packages/injector) - dependency injection
  * [dio](https://pub.dev/packages/dio) - for REST networking
  * [graphql](https://pub.dev/packages/graphql) - for GraphQL networking
  * [built_value](https://pub.dev/packages/built_value) - for plain objects
  * [flutter_markdown](https://pub.dev/packages/flutter_markdown) - for markdown parse
* Architecture
  * Clean Architecture
  * BLOC
    
 ## Authentification
 To make things work you must get **Git hub api keys** according to this [guide](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/). During registration indicate **Authorization callback URL** parameter as follows `"http://example.com/path"`. 
 
 Also create **client_keys/lib/client_keys.json** file in root folder as follow:
 
 ```json
 {
   "client_id":"/* your client id */",
   "client_secret":"/* your client secret */"
 }
 ```
 
 Both application implementation (korlin & flutter) will use **client_keys/lib/client_keys.json** to auth networking with
 git hub api.
