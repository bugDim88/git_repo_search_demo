import 'package:gitreposearcherflutter/domain/get_repo_details_use_case.dart';
import 'package:gitreposearcherflutter/model/repo_info_model.dart';
import 'package:rxdart/rxdart.dart';

class RepoInfoBlock {
  RepoInfoBlock(this._getRepoDetailUseCase);

  final GetRepoDetailUseCase _getRepoDetailUseCase;

  final _errorEventSubject = PublishSubject<Exception>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final _repoInfoDataSubject = PublishSubject<RepoInfoModel>();

  String _repoName;
  String _repoOwner;

  Stream<Exception> get errorEvent => _errorEventSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  Stream<RepoInfoModel> get repoInfoData =>
      _repoInfoDataSubject.stream;

  Future<void> init(String repoName, String repoOwner) async =>
      dataLoad(() async {
        _repoName = repoName;
        _repoOwner = repoOwner;
        final result = await _getRepoDetailUseCase
            .execute(GetRepoDetailUseCaseParams(repoName, repoOwner));
        _repoInfoDataSubject.sink.add(result);
      });

  Future<void> reload() async {
    try {
      final result = await _getRepoDetailUseCase
          .execute(GetRepoDetailUseCaseParams(_repoName, _repoOwner));
      _repoInfoDataSubject.sink.add(result);
    } on Exception catch (e) {
      _errorEventSubject.sink.add(e);
    }
  }

  Future<void> dataLoad(Future<void> Function() block) async {
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
    _repoInfoDataSubject.close();
  }
}
