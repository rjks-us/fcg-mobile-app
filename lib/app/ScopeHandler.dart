import 'dart:convert';

import 'package:flutter/services.dart';

class ScopeHandler {

  late Map<String, dynamic> _scopeConfig;
  late List<int> _currentOwnedScopes;

  late List<Scope> _possibleScopeCollection;

  ScopeHandler(List<int> _ownedScopes) {
    this._currentOwnedScopes = _ownedScopes;
    load();
  }

  load() async {
    final String response = await rootBundle.loadString('assets/app_admin_scopes.json');
    this._scopeConfig = await jsonDecode(response);

    this._scopeConfig['scopes'].forEach((element) => _possibleScopeCollection.add(new Scope(element)));
  }

  bool hasPermission(int scopeId) {
    if(_currentOwnedScopes.contains(scopeId)) return true;

    for(int i = 0; i < _possibleScopeCollection.length; i++) {
      Scope scope = _possibleScopeCollection[i];

      if(scope.id == scopeId && scope.parent.contains(scopeId)) return true;
    }
    return false;
  }

}

class Scope {

  late Map<String, dynamic> _query;

  late String name, description;
  late int id;

  late List<int> parent;

  Scope(Map<String, dynamic> _query) {

    this._query = _query;

    this.name = _query['name'];
    this.id = _query['id'];
    this.description = _query['description'];

    this.parent = _query['inherit'];
  }

}