import 'package:fcg_app/app/Storage.dart';
import 'package:fcg_app/app/Timetable.dart';
import 'package:fcg_app/network/RequestHandler.dart' as RequestHandler;

class Account {

  Account();

  Future<bool> loginUser(String username, String password) async {

    String token = await getAdminSessionToken();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/admin/login');

    request.setHeader(request.buildAccessHeader(token));

    request.setBody({
      "username": username,
      "password": password
    });

    var response = request.send(), state = false;

    await response.processResponse();

    response.onSuccess((data) {

      state = true;

      List<dynamic> _list = data['scopes'];
      List<int> _scopes = [];

      _list.forEach((element) => _scopes.add(int.parse(element.toString())));

      saveString('var-admin-token', data['token']);
      saveString('var-admin-username', username);
      saveString('var-admin-session-timeout', data['expires']);
      saveIntList('var-admin-scopes', _scopes);

      print('[DEVICE] The credentials for $username are valid, token received');
    });

    response.onUnauthorized((data) {
      print('[DEVICE] The credentials for $username are invalid');
    });

    response.onError((httpResponse) {
      print('[DEVICE] The credentials for $username are invalid');
    });

    response.registerListeners();

    return state;
  }

  Future<bool> validateSession() async {

    String token = await getAdminSessionToken();

    RequestHandler.Request request = RequestHandler.Request('GET', 'v1/admin/me');

    request.setHeader(request.buildAccessHeader(token));

    var response = request.send();
    await response.processResponse();

    return (response.getStatusCode() != 401 && response.getStatusCode() != 500);
  }

  Future<bool> signOut() async {
    String token = await getAdminSessionToken();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/admin/logout');

    request.setHeader(request.buildAccessHeader(token));

    var response = request.send(), state = false;

    await response.processResponse();

    response.onSuccess((data) {
      state = true;

      updateAdminSessionToken('');
      updateAdminUsername('');
      updateSessionTimeout('');
      updateAdminUserScopes([]);

      print('[DEVICE] The administration account has been logged out');
    });

    response.onUnauthorized((data) {
      print('[DEVICE] The credentials which are required for the logout are invalid');
    });

    response.onError((httpResponse) {
      print('[DEVICE] The credentials which are required for the logout are invalid');
    });

    response.registerListeners();

    return state;
  }

  Future<bool> manipulateTimetablentry(TimetableEntry timetableEntry, int type, String message) async {
    String token = await getAdminSessionToken();

    RequestHandler.Request request = RequestHandler.Request('POST', 'v1/admin/manipulize');

    request.setBody({
      "rayid": timetableEntry.rayId,
      "class": timetableEntry.timetableClass.id,
      "course": timetableEntry.timetableSubject.id,
      "status": {
        "type": type,
        "message": message
      }
    });

    request.setHeader(request.buildAccessHeader(token));

    var response = request.send(), state = false;

    await response.processResponse();

    print(response.getStatusCode());
    print(response.body);

    response.onSuccess((data) {
      state = true;
      print('[DEVICE] The timetable entry ${timetableEntry.timetableSubject.name} #${timetableEntry.timetableSubject.id} has been manipulized.');
    });

    response.onUnauthorized((data) {
      print('[DEVICE] Unable to manipulize ${timetableEntry.timetableSubject.name} #${timetableEntry.timetableSubject.id} 1');
    });

    response.onError((httpResponse) {
      print('[DEVICE] Unable to manipulize ${timetableEntry.timetableSubject.name} #${timetableEntry.timetableSubject.id} 2s');
    });

    response.registerListeners();

    return state;
  }

  Future<bool> hasScope(int scope) async {
    List<int> _scopes = await getAdminScopes();

    if(_scopes.contains(1)) return true;

    return (_scopes.contains(scope));
  }

  Future<String> getAdminSessionToken() async {
    String token = await getString('var-admin-token');
    return token;
  }

  Future<String> getAdminUsername() async {
    String name = await getString('var-admin-username');
    return name;
  }

  Future<String> getAdminSessionTimeout() async {
    String name = await getString('var-admin-session-timeout');
    return name;
  }

  Future<List<int>> getAdminScopes() async {
    List<int> name = await getIntList('var-admin-scopes');
    return name;
  }

  void updateAdminSessionToken(String token) {saveString('var-admin-token', token);}

  void updateSessionTimeout(String timeout) {saveString('var-admin-session-timeout', timeout);}

  void updateAdminUserScopes(List<int> scopes) {saveIntList('var-admin-scopes', scopes);}

  void updateAdminUsername(String username) {saveString('var-admin-username', username);}

  Future<AccountState> hasAdminAccountRegistered() async {
    String token = await getString('var-admin-token');

    if(token.isEmpty) return AccountState.NOT_LOGGED_IN;

    bool sessionValid = await validateSession();

    if(sessionValid) {
      return AccountState.LOGGED_IN;
    } else {
      updateAdminSessionToken('');
      updateAdminUsername('');
      updateSessionTimeout('');

      return AccountState.SESSION_EXPIRED;
    }
  }
}

enum AccountState {
  NOT_LOGGED_IN, SESSION_EXPIRED, LOGGED_IN
}