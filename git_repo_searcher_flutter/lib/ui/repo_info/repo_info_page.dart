import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gitreposearcherflutter/custom_icons.dart';
import 'package:gitreposearcherflutter/model/repo_info_model.dart';
import 'package:gitreposearcherflutter/model/repo_item_model.dart';
import 'package:gitreposearcherflutter/ui/repo_info/repo_info_block.dart';
import 'package:gitreposearcherflutter/ui_functions.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

class RepoInfoWidget extends StatefulWidget {
  static final route = "repo_info_page";

  @override
  _RepoInfoWidgetState createState() => _RepoInfoWidgetState();
}

class _RepoInfoWidgetState extends State<RepoInfoWidget> {
  final block = Injector.appInstance.getDependency<RepoInfoBlock>();
  final subscription = CompositeSubscription();
  BuildContext _scaffoldContext;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _blockInit();
      _blockSubscribe();
    });
  }

  @override
  void dispose() {
    subscription.dispose();
    block.dispose();
    super.dispose();
  }

  void _blockInit() {
    final RepoItemModel argument = ModalRoute.of(context).settings.arguments;
    block.init(argument.title, argument.owner);
  }

  void _blockSubscribe() {
    subscription.add(block.errorEvent.listen((event) {
      showExceptionSnackBar(event, _scaffoldContext);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final RepoItemModel argument = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(argument.title),
      ),
      body: Builder(
        builder: (ctx) {
          _scaffoldContext = ctx;
          return RefreshIndicator(
            onRefresh: block.reload,
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  StreamBuilder<RepoInfoModel>(
                      stream: block.repoInfoData,
                      builder: (context, snapshot) {
                        final repoData = snapshot.data;
                        final textTheme = Theme.of(context).textTheme;
                        if (repoData == null) return Container();
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 16,
                              ),
                              Text(repoData.ownerLogin,
                                  style: textTheme.caption),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(repoData.name, style: textTheme.headline6),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(repoData.description ?? "",
                                  style: textTheme.bodyText1),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.star_border),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text("${repoData.starsCount} stars",
                                          style: textTheme.bodyText2),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(CustomIcons.repo_forked),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text("${repoData.forksCount} forks",
                                          style: textTheme.bodyText2),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Issues",
                                    style: textTheme.bodyText2,
                                  ),
                                  Text(repoData.issueCount.toString()),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Pull Request",
                                      style: textTheme.bodyText2),
                                  Text(repoData.pullRequestCount.toString()),
                                ],
                              ),
                              Divider(),
                              repoData.readMe == null
                                  ? Center(child: Text("no read me"))
                                  : MarkdownBody(data: repoData.readMe),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        );
                      }),
                  StreamBuilder<bool>(
                    stream: block.isLoading,
                    builder: (ctx, snapshot) {
                      final height =
                          MediaQuery.of(ctx).size.height - kToolbarHeight;
                      return Visibility(
                        visible: snapshot.data == true,
                        child: SizedBox(
                            height: height,
                            child: Center(child: CircularProgressIndicator())),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
