import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:gitreposearcherflutter/ui/init_page/init_block.dart';
import 'package:gitreposearcherflutter/ui/repos_search/repo_search_page.dart';
import 'package:gitreposearcherflutter/ui/strings.dart';
import 'package:gitreposearcherflutter/ui_functions.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InitPageWidget extends StatefulWidget {
  static final route = "init_page";

  @override
  _InitPageWidgetState createState() => _InitPageWidgetState();
}

class _InitPageWidgetState extends State<InitPageWidget> {
  final block = Injector.appInstance.getDependency<InitBlock>();
  final blockSubscription = CompositeSubscription();

  @override
  void initState() {
    super.initState();
    block.init();
    // Subscribe to block streams when context will be ready
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _subscribeToBlock();
    });
  }

  @override
  void dispose() {
    blockSubscription.dispose();
    block.dispose();
    super.dispose();
  }

  void _subscribeToBlock() {
    blockSubscription.add(block.authStatusChangeEvent.listen((event) {
      if (event == true)
        Navigator.of(context).pushReplacementNamed(RepoSearchPageWidget.route);
    }));
    blockSubscription.add(block.errorEvent.listen((event) {
      showExceptionSnackBar(event, context);
    }));
  }

  String _getAuthUrl() => Uri.https("github.com", "login/oauth/authorize", {
        "client_id": kClientId,
        "scope": "user, rep,read:org",
        "redirect_uri": kRedirectUrl
      }).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(InitPageWidget.route),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<bool>(
              stream: block.webViewVisibility,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data == true,
                  child: WebView(
                    initialUrl: _getAuthUrl(),
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageStarted: (url) {
                      if (url.contains(kRedirectUrl)) {
                        final code = Uri.parse(url).queryParameters["code"];
                        block.signIn(code);
                      }
                    },
                  ),
                );
              }),
          StreamBuilder<bool>(
            stream: block.isLoading,
            builder: (context, snapshot) {
              final status = snapshot.data;
              return Visibility(
                visible: status == true,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          )
        ],
      ),
    );
  }
}
