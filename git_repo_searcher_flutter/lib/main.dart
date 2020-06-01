import 'package:flutter/material.dart';
import 'package:gitreposearcherflutter/ui/init_page/init_page.dart';
import 'package:gitreposearcherflutter/ui/repo_info/repo_info_page.dart';
import 'package:gitreposearcherflutter/ui/repos_search/repo_search_page.dart';

import 'di/register_injections.dart';

void main() {
  registerInjections();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Git Repo Searcher',
      theme: ThemeData(
        primaryColor: Colors.white,
        primaryColorDark: Color(0xffc8c8c8),
        accentColor: Color(0xff5b8cc6),
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: InitPageWidget.route,
      routes: {
        InitPageWidget.route: (ctx) => InitPageWidget(),
        RepoInfoWidget.route: (ctx) => RepoInfoWidget(),
        RepoSearchPageWidget.route: (ctx) => RepoSearchPageWidget(),
      },
    );
  }
}
