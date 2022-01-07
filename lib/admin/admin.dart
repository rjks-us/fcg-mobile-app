import 'package:fcg_app/storage/storage.dart';
import 'package:fcg_app/api/httpBuilder.dart' as httpBuilder;


Future<Administrator> loginUser(String username, String password) async {

  Administrator admin = new Administrator(username, false);
  httpBuilder.Request request = new httpBuilder.Request('POST', 'v1/admin/login', false, true, false);

  request.setBody({
    "username": username,
    "password": password
  });

  httpBuilder.Response response = await request.flush();
  await response.checkCache();

  response.onSuccess((body) async {

    print('Logged in as $username');
    save('var-admin-token', body['token']);

    admin = await validateSession(body['token']);
  });

  response.onUnauthorized((body) {
    print('Invalid Credentials');
  });

  response.onInvalidRequest((bodx) => {
    print('Invalid request: $bodx')
  });

  response.onNoResult((data) {});

  response.onError((data) {});

  await response.process();

  return admin;
}

Future<Administrator> validateSession(String token) async {

  Administrator admin = new Administrator('', false);

  httpBuilder.Request request = new httpBuilder.Request('GET', 'v1/admin/me', true, true, false);
  request.setHeader({
    'Authorization': token
  });

  httpBuilder.Response response = await request.flush();

  response.onSuccess((body) {
    admin.setValid();

    admin.setName(body['name']);
    admin.setEmail(body['email']);
    admin.setScopes(body['scopes']);

    List<String> tmp = admin.scopes.map((e) => e.toString()).toList();

    saveStringList('var-admin-scopes', tmp);
  });

  response.onUnauthorized((body) { ///Invalid token, logging out

  });

  response.onNoResult((data) {});

  response.onError((data) {});

  await response.process();

  return admin;
}

logOut() async {
  saveStringList('var-admin-scopes', []);
  save('var-admin-token', 'not-defined');

  print('Admin account Logged out');
}

Future<bool> isLoggedIn() async {
  if(await getString('var-admin-token') == 'not-defined') {
    return false;
  }
  return true;
}

class Administrator {

  late String name, email, iat;
  late List<int> scopes = [];

  late bool loggedIn;

  Administrator(String name, bool valid) {
    name = name;
    loggedIn = valid;
  }

  setEmail(String mail) {
    this.email = mail;
  }

  setIat(String iat) {
    this.iat = iat;
  }

  setValid() {
    this.loggedIn = true;
  }

  setScopes(List<int> scope) {
    this.scopes = scope;
  }

  setName(String name) {
    this.name = name;
  }

  isValid() {
    return loggedIn;
  }

  hasScope(int scope) {
    return scopes.contains(scope);
  }

  getIat() {
    return iat;
  }
}