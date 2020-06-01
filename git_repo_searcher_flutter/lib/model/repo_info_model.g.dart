// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_info_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RepoInfoModel extends RepoInfoModel {
  @override
  final String ownerLogin;
  @override
  final String name;
  @override
  final String description;
  @override
  final int starsCount;
  @override
  final int forksCount;
  @override
  final int issueCount;
  @override
  final int pullRequestCount;
  @override
  final String readMe;

  factory _$RepoInfoModel([void Function(RepoInfoModelBuilder) updates]) =>
      (new RepoInfoModelBuilder()..update(updates)).build();

  _$RepoInfoModel._(
      {this.ownerLogin,
      this.name,
      this.description,
      this.starsCount,
      this.forksCount,
      this.issueCount,
      this.pullRequestCount,
      this.readMe})
      : super._() {
    if (ownerLogin == null) {
      throw new BuiltValueNullFieldError('RepoInfoModel', 'ownerLogin');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('RepoInfoModel', 'name');
    }
    if (starsCount == null) {
      throw new BuiltValueNullFieldError('RepoInfoModel', 'starsCount');
    }
    if (forksCount == null) {
      throw new BuiltValueNullFieldError('RepoInfoModel', 'forksCount');
    }
    if (issueCount == null) {
      throw new BuiltValueNullFieldError('RepoInfoModel', 'issueCount');
    }
    if (pullRequestCount == null) {
      throw new BuiltValueNullFieldError('RepoInfoModel', 'pullRequestCount');
    }
  }

  @override
  RepoInfoModel rebuild(void Function(RepoInfoModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RepoInfoModelBuilder toBuilder() => new RepoInfoModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RepoInfoModel &&
        ownerLogin == other.ownerLogin &&
        name == other.name &&
        description == other.description &&
        starsCount == other.starsCount &&
        forksCount == other.forksCount &&
        issueCount == other.issueCount &&
        pullRequestCount == other.pullRequestCount &&
        readMe == other.readMe;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, ownerLogin.hashCode), name.hashCode),
                            description.hashCode),
                        starsCount.hashCode),
                    forksCount.hashCode),
                issueCount.hashCode),
            pullRequestCount.hashCode),
        readMe.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RepoInfoModel')
          ..add('ownerLogin', ownerLogin)
          ..add('name', name)
          ..add('description', description)
          ..add('starsCount', starsCount)
          ..add('forksCount', forksCount)
          ..add('issueCount', issueCount)
          ..add('pullRequestCount', pullRequestCount)
          ..add('readMe', readMe))
        .toString();
  }
}

class RepoInfoModelBuilder
    implements Builder<RepoInfoModel, RepoInfoModelBuilder> {
  _$RepoInfoModel _$v;

  String _ownerLogin;
  String get ownerLogin => _$this._ownerLogin;
  set ownerLogin(String ownerLogin) => _$this._ownerLogin = ownerLogin;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  int _starsCount;
  int get starsCount => _$this._starsCount;
  set starsCount(int starsCount) => _$this._starsCount = starsCount;

  int _forksCount;
  int get forksCount => _$this._forksCount;
  set forksCount(int forksCount) => _$this._forksCount = forksCount;

  int _issueCount;
  int get issueCount => _$this._issueCount;
  set issueCount(int issueCount) => _$this._issueCount = issueCount;

  int _pullRequestCount;
  int get pullRequestCount => _$this._pullRequestCount;
  set pullRequestCount(int pullRequestCount) =>
      _$this._pullRequestCount = pullRequestCount;

  String _readMe;
  String get readMe => _$this._readMe;
  set readMe(String readMe) => _$this._readMe = readMe;

  RepoInfoModelBuilder();

  RepoInfoModelBuilder get _$this {
    if (_$v != null) {
      _ownerLogin = _$v.ownerLogin;
      _name = _$v.name;
      _description = _$v.description;
      _starsCount = _$v.starsCount;
      _forksCount = _$v.forksCount;
      _issueCount = _$v.issueCount;
      _pullRequestCount = _$v.pullRequestCount;
      _readMe = _$v.readMe;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RepoInfoModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RepoInfoModel;
  }

  @override
  void update(void Function(RepoInfoModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RepoInfoModel build() {
    final _$result = _$v ??
        new _$RepoInfoModel._(
            ownerLogin: ownerLogin,
            name: name,
            description: description,
            starsCount: starsCount,
            forksCount: forksCount,
            issueCount: issueCount,
            pullRequestCount: pullRequestCount,
            readMe: readMe);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
