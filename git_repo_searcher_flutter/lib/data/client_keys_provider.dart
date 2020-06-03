import 'package:gitreposearcherflutter/model/client_key_model.dart';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

class ClientKeyProvider {
  final String _path;
  ClientKeyModel _keysModel;

  ClientKeyProvider(this._path);

  Future<ClientKeyModel> loadKeys() async {
    if (_keysModel != null) return _keysModel;
    final jsonString = await rootBundle.loadString(_path);
    final map = json.decode(jsonString);
    _keysModel = ClientKeyModel((b) => b
      ..clientId = map["client_id"]
      ..clientSecret = map["client_secret"]);
    return _keysModel;
  }
}
