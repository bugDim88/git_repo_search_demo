import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gitreposearcherflutter/model/repo_item_model.dart';
import 'package:gitreposearcherflutter/ui/repo_info/repo_info_page.dart';
import 'package:gitreposearcherflutter/ui/repos_search/repos_search_block.dart';
import 'package:gitreposearcherflutter/ui_functions.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

class RepoSearchPageWidget extends StatefulWidget {
  static final route = "repo_search_page";

  @override
  _RepoSearchPageWidgetState createState() => _RepoSearchPageWidgetState();
}

class _RepoSearchPageWidgetState extends State<RepoSearchPageWidget> {
  BuildContext scaffoldContext;
  final block = Injector.appInstance.getDependency<RepoSearchBlock>();
  final searchTextController = TextEditingController();
  final subscription = CompositeSubscription();
  var scrollController = ScrollController();
  var reposList = List<RepoItemModel>();

  @override
  void initState() {
    super.initState();
    block.init();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _subscribeToBlock();
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    subscription.dispose();
    block.dispose();
    super.dispose();
  }

  void _subscribeToBlock() {
    subscription.add(block.errorEvent.listen((event) {
      showExceptionSnackBar(event, scaffoldContext);
    }));
    subscription.add(block.reposList.listen((list) {
      setState(() {
        switch (list.listType) {
          case PagedListLoadType.init:
            scrollController = ScrollController();
            reposList = list.items;
            break;
          case PagedListLoadType.next:
            reposList.addAll(list.items);
            break;
        }
      });
    }));
  }

  Widget _getRepoTile(RepoItemModel repo) => ListTile(
        key: ObjectKey(repo),
        onTap: () => Navigator.of(context)
            .pushNamed(RepoInfoWidget.route, arguments: repo),
        isThreeLine: true,
        title: Text(
          repo.title,
          maxLines: 1,
        ),
        subtitle: Text(
          repo.description ?? "",
          maxLines: 2,
        ),
      );

  Widget _getEdgeWidget() => StreamBuilder<PagedListEdgeItem>(
        stream: block.pagedListEdgeItem,
        builder: (ctx, snapshot) {
          if (snapshot.data == null) return Container();
          Widget result;
          switch (snapshot.data.networkStatus) {
            case NetworkStatus.load:
              result = Center(
                child: CircularProgressIndicator(),
              );
              break;
            case NetworkStatus.error:
              result = Center(
                child: Text(snapshot.data.error.toString()),
              );
              break;
            case NetworkStatus.success:
              result = Container();
              break;
          }
          return result;
        },
      );

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        scrollController.position.extentAfter == 0) {
      block.loadNextPage();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            StreamBuilder<bool>(
                stream: block.appBarExpandState,
                builder: (context, snapshot) {
                  return snapshot.data == true
                      ? IconButton(
                          onPressed: () => block.expandAppBar(false),
                          icon: Icon(Icons.arrow_back),
                        )
                      : SizedBox(
                          width: 0,
                        );
                }),
            StreamBuilder<bool>(
                stream: block.appBarExpandState,
                builder: (context, snapshot) {
                  return Visibility(
                      visible: snapshot.data == false,
                      child: SizedBox(
                        width: 16,
                      ));
                }),
            Expanded(
              child: Stack(
                children: <Widget>[
                  StreamBuilder<bool>(
                      stream: block.appBarExpandState,
                      builder: (context, snapshot) {
                        return Visibility(
                          visible: snapshot.data == true,
                          child: TextField(
                            controller: searchTextController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) => block.search(value),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'search repo'),
                          ),
                        );
                      }),
                  StreamBuilder<bool>(
                      stream: block.appBarExpandState,
                      builder: (context, snapshot) {
                        return Visibility(
                            visible: snapshot.data == false,
                            child: Center(child: Text("Git Repo Searcher", textAlign: TextAlign.center,)));
                      }),
                ],
              ),
            ),
            StreamBuilder<bool>(
                stream: block.appBarExpandState,
                builder: (context, snapshot) {
                  return Visibility(
                      visible: snapshot.data == true,
                      child: SizedBox(
                        width: 16,
                      ));
                }),
          ],
        ),
        actions: <Widget>[
          StreamBuilder<bool>(
              stream: block.appBarExpandState,
              builder: (context, snapshot) {
                return Visibility(
                    visible: snapshot.data == false,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => block.expandAppBar(true),
                    ));
              })
        ],
      ),
      body: Builder(
        builder: (context) {
          scaffoldContext = context;
          return Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: block.reload,
                child: NotificationListener(
                  onNotification: _handleScrollNotification,
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: reposList.length + 1,
                      itemBuilder: (ctx, index) {
                        if (index == reposList.length)
                          return _getEdgeWidget();
                        else
                          return _getRepoTile(reposList[index]);
                      }),
                ),
              ),
              StreamBuilder<bool>(
                stream: block.isLoading,
                builder: (ctx, snapshot) => Visibility(
                  visible: snapshot.data == true,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
