// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_key_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClientKeyModel extends ClientKeyModel {
  @override
  final String clientId;
  @override
  final String clientSecret;

  factory _$ClientKeyModel([void Function(ClientKeyModelBuilder) updates]) =>
      (new ClientKeyModelBuilder()..update(updates)).build();

  _$ClientKeyModel._({this.clientId, this.clientSecret}) : super._() {
    if (clientId == null) {
      throw new BuiltValueNullFieldError('ClientKeyModel', 'clientId');
    }
    if (clientSecret == null) {
      throw new BuiltValueNullFieldError('ClientKeyModel', 'clientSecret');
    }
  }

  @override
  ClientKeyModel rebuild(void Function(ClientKeyModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientKeyModelBuilder toBuilder() =>
      new ClientKeyModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientKeyModel &&
        clientId == other.clientId &&
        clientSecret == other.clientSecret;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, clientId.hashCode), clientSecret.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClientKeyModel')
          ..add('clientId', clientId)
          ..add('clientSecret', clientSecret))
        .toString();
  }
}

class ClientKeyModelBuilder
    implements Builder<ClientKeyModel, ClientKeyModelBuilder> {
  _$ClientKeyModel _$v;

  String _clientId;
  String get clientId => _$this._clientId;
  set clientId(String clientId) => _$this._clientId = clientId;

  String _clientSecret;
  String get clientSecret => _$this._clientSecret;
  set clientSecret(String clientSecret) => _$this._clientSecret = clientSecret;

  ClientKeyModelBuilder();

  ClientKeyModelBuilder get _$this {
    if (_$v != null) {
      _clientId = _$v.clientId;
      _clientSecret = _$v.clientSecret;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientKeyModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClientKeyModel;
  }

  @override
  void update(void Function(ClientKeyModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClientKeyModel build() {
    final _$result = _$v ??
        new _$ClientKeyModel._(clientId: clientId, clientSecret: clientSecret);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
