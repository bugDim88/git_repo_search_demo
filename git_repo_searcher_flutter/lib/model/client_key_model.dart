import 'package:built_value/built_value.dart';

part 'client_key_model.g.dart';

abstract class ClientKeyModel
    implements Built<ClientKeyModel, ClientKeyModelBuilder> {
  String get clientId;

  String get clientSecret;

  ClientKeyModel._();

  factory ClientKeyModel([void Function(ClientKeyModelBuilder) updates]) =
      _$ClientKeyModel;
}
