import 'dart:async';

import 'package:gitreposearcherflutter/domain/search_repo_use_case.dart';
import 'package:gitreposearcherflutter/model/repo_item_model.dart';
import 'package:rxdart/rxdart.dart';

class RepoSearchBlock {
  RepoSearchBlock(this._searchRepoUseCase);

  final SearchRepoUseCase _searchRepoUseCase;

  final _errorEventSubject = PublishSubject<Exception>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final _reposListSubject = BehaviorSubject<PagedList<RepoItemModel>>();
  final _listPagingItem = BehaviorSubject<PagedListEdgeItem>();
  final _appBarExpandState = BehaviorSubject<bool>.seeded(false);

  String _lastQuery = null;

  Stream<Exception> get errorEvent => _errorEventSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  Stream<PagedList<RepoItemModel>> get reposList => _reposListSubject.stream;

  Stream<PagedListEdgeItem> get pagedListEdgeItem => _listPagingItem.stream;

  Stream<bool> get appBarExpandState => _appBarExpandState.stream;

  Future<void> init() async => _dataLoad(() async {
        final items = await _searchRepoUseCase.execute();
        _reposListSubject.sink.add(PagedList.init(items));
      });

  Future<void> search(String query) async {
    _lastQuery = query;
    _dataLoad(() async {
      final items = await _searchRepoUseCase.execute(query);
      _reposListSubject.sink.add(PagedList.init(items));
    });
  }

  Future<void> reload() async {
    try {
      final result = await _searchRepoUseCase.execute(_lastQuery);
      _reposListSubject.sink.add(PagedList.init(result));
    } on Exception catch (e) {
      _errorEventSubject.sink.add(e);
    }
  }

  Future<void> loadNextPage() async {
    _listPagingItem.sink.add(PagedListEdgeItem.loading());
    try {
      final items = await _searchRepoUseCase.nextPage();
      _reposListSubject.sink.add(PagedList.next(items));
      _listPagingItem.sink.add(PagedListEdgeItem.success());
    } on NoNextPage catch (_) {
      _listPagingItem.sink.add(PagedListEdgeItem.success());
    } on Exception catch (e) {
      _listPagingItem.sink.add(PagedListEdgeItem.error(e));
    }
  }

  void expandAppBar(bool expandState) =>
      _appBarExpandState.sink.add(expandState);

  Future<void> _dataLoad(Future<void> Function() block) async {
    _isLoadingSubject.sink.add(true);
    try {
      await block();
    } on Exception catch (e) {
      _errorEventSubject.sink.add(e);
    } finally {
      _isLoadingSubject.sink.add(false);
    }
  }

  void dispose() {
    _errorEventSubject.close();
    _isLoadingSubject.close();
    _reposListSubject.close();
    _listPagingItem.close();
    _appBarExpandState.close();
  }
}

class PagedList<T> {
  final List<T> items;
  final PagedListLoadType listType;

  factory PagedList.init(List<T> items) =>
      PagedList(items, PagedListLoadType.init);

  factory PagedList.next(List<T> items) =>
      PagedList(items, PagedListLoadType.next);

  PagedList(this.items, this.listType);
}

enum PagedListLoadType { init, next }

enum NetworkStatus { load, error, success }

class PagedListEdgeItem {
  final NetworkStatus networkStatus;
  final Exception error;

  PagedListEdgeItem(this.networkStatus, [this.error]);

  factory PagedListEdgeItem.loading() => PagedListEdgeItem(NetworkStatus.load);

  factory PagedListEdgeItem.error(Exception error) =>
      PagedListEdgeItem(NetworkStatus.error, error);

  factory PagedListEdgeItem.success() =>
      PagedListEdgeItem(NetworkStatus.success);
}

class NoNextPage implements Exception {}
