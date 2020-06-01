// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_item_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RepoItemModel extends RepoItemModel {
  @override
  final int id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String owner;

  factory _$RepoItemModel([void Function(RepoItemModelBuilder) updates]) =>
      (new RepoItemModelBuilder()..update(updates)).build();

  _$RepoItemModel._({this.id, this.title, this.description, this.owner})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('RepoItemModel', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('RepoItemModel', 'title');
    }
    if (owner == null) {
      throw new BuiltValueNullFieldError('RepoItemModel', 'owner');
    }
  }

  @override
  RepoItemModel rebuild(void Function(RepoItemModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RepoItemModelBuilder toBuilder() => new RepoItemModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RepoItemModel &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        owner == other.owner;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, id.hashCode), title.hashCode), description.hashCode),
        owner.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RepoItemModel')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('owner', owner))
        .toString();
  }
}

class RepoItemModelBuilder
    implements Builder<RepoItemModel, RepoItemModelBuilder> {
  _$RepoItemModel _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _owner;
  String get owner => _$this._owner;
  set owner(String owner) => _$this._owner = owner;

  RepoItemModelBuilder();

  RepoItemModelBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _description = _$v.description;
      _owner = _$v.owner;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RepoItemModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RepoItemModel;
  }

  @override
  void update(void Function(RepoItemModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RepoItemModel build() {
    final _$result = _$v ??
        new _$RepoItemModel._(
            id: id, title: title, description: description, owner: owner);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
