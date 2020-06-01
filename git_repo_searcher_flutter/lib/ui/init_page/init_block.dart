import 'package:gitreposearcherflutter/domain/check_sign_in_status_use_case.dart';
import 'package:gitreposearcherflutter/domain/sign_in_use_case.dart';
import 'package:rxdart/rxdart.dart';

class InitBlock {
  InitBlock(this._checkSignInStatusUseCase, this._signInUseCase);

  final CheckSignInStatusUseCase _checkSignInStatusUseCase;
  final SignInUseCase _signInUseCase;

  final _errorEventSubject = PublishSubject<Exception>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final _authStatusEventSubject = PublishSubject<bool>();
  final _webViewVisibility = BehaviorSubject<bool>.seeded(false);

  Stream<Exception> get errorEvent => _errorEventSubject.stream;

  Stream<bool> get isLoading => _isLoadingSubject.stream;

  Stream<bool> get authStatusChangeEvent => _authStatusEventSubject.stream;

  Stream<bool> get webViewVisibility => _webViewVisibility.stream;

  Future<void> init() async => dataLoad(() async {
        final signInResult = await _checkSignInStatusUseCase.execute();
        if (signInResult) {
          _webViewVisibility.sink.add(false);
          _authStatusEventSubject.sink.add(signInResult);
        } else {
          _webViewVisibility.sink.add(true);
        }
      });

  Future<void> signIn(String code) async => dataLoad(() async {
        final signInResult = await _signInUseCase.execute(code);
        if (signInResult) {
          _webViewVisibility.sink.add(false);
          _authStatusEventSubject.sink.add(signInResult);
        } else {
          _webViewVisibility.sink.add(true);
        }
      });

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
    _authStatusEventSubject.close();
    _webViewVisibility.close();
  }
}
