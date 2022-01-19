import 'dart:convert';
import 'dart:math';

import 'package:fcg_app/api/helper.dart';
import 'package:fcg_app/storage/storage.dart';
import 'package:http/http.dart' as http;

Future<bool> isDeviceSetUp() async {
  var username = await getString('var-username'), className = await getString('var-class-name'), classId = await getInt('var-class-id');
  if(username != 'not-defined' && className != 'not-defined' && classId != 0) return true;
  return false;
}

///Check if the current device is registered
Future<bool> deviceRegistered() async {
  return (await isSet('global-access-token') && await isSet('global-access-refresh-token'));
}

///Creates device to database, make sure all properties are set before!
register() async {
  var request = createRequest('POST', 'v1/devices/create-device');

  print(request);

  var username = await getString('var-username');
  var courses = await getIntList('var-courses');
  var classId = await getInt('var-class-id');

  if(classId == 0) classId = 242;

  var push = '123123123123123123123123123123123123123123123213';
  var platform = 'IOS/15.0.2';

  request.body = jsonEncode({
    'name': username,
    'platform': platform,
    'device': {
      'model': 'IPhone 11 Pro',
      'ios': '15.0.2',
      'id': '37612t687xdt167854zq8118z243875zr78zwe87rztcc67t278z78cz32c87zn7843z5b',
    },
    'settings': {
      'notifications': true,
    },
    'courses': courses,
    'class': classId,
    'push': push
  });

  print(request.body);

  request.headers.addAll(await getHeader());

  http.StreamedResponse response;

  try {
    response = await request.send();
  } catch(_) {
    return throw Error();
  }

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    print(body);

    Map<String, dynamic> data = body['data'];

    save('global-access-token', data['token']);
    save('global-access-refresh-token', data['refresh']);

    save('var-creation-date', '${DateTime.now().millisecondsSinceEpoch}');

    print('Successfully registered the current device.');
  } else {
    print(await response.stream.bytesToString());
    print(response.reasonPhrase);
  }
}

///Refreshes the current session with the invalid token and the valid refresh token
Future<bool> refreshSession() async {
  var request = createRequest('POST', 'v1/devices/refresh');

  request.headers.addAll(await getHeader());
  request.body = jsonEncode({
    'token': await getAccessToken(),
    'refresh': await getRefreshToken()
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    Map<String, dynamic> data = body['data'];

    save('global-access-token', data['token']);
    save('global-access-refresh-token', data['reset']);

    print('Successfully updated the current device access tokens.');
  } else {
    return false; /// <-- This should never happen to a registered device
  }
  return true;
}


Future<bool> isSessionValid() async {
  var request = createRequest('GET', 'v1/devices/me');
  request.headers.addAll(await getHeader());

  var response = await request.send();

  return (response.statusCode != 401);
}

Future<String> getAccessToken() async {
  if(await deviceRegistered()) return await getString('global-access-token');
  return ' ';
}

Future<String> getRefreshToken() async {
  if(await deviceRegistered()) return await getString('global-access-refresh-token');
  return ' ';
}

Future<Map<String, String>> getHeader() async {
  String token = await getAccessToken();
  var header = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  return header;
}

///API ENDPOINTS

Future<Map<String, dynamic>?> me() async {
  if(!await isSessionValid()) await refreshSession();

  var request = createRequest('GET', 'v1/devices/me');
  request.headers.addAll(await getHeader());

  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //401 or 400
    return null;
  }
}

Future<Map<String, dynamic>?> updateClass(int classId) async {
  if(!await isSessionValid()) await refreshSession();

  var request = createRequest('POST', 'v1/devices/update/class');
  request.headers.addAll(await getHeader());

  request.body = jsonEncode({
    'class': classId
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

Future<Map<String, dynamic>?> updateCourses(List<int> courses) async {
  if(!await isSessionValid()) await refreshSession();

  var request = createRequest('POST', 'v1/devices/update/course');
  request.headers.addAll(await getHeader());

  request.body = jsonEncode({
    'courses': courses
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

Future<Map<String, dynamic>?> updateToken(String token) async {
  if(!await isSessionValid()) await refreshSession();

  var request = createRequest('POST', 'v1/devices/update/token');
  request.headers.addAll(await getHeader());

  request.body = jsonEncode({
    'token': token
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}

///DANGER ZONE!!!!
Future<bool> deleteThisDevice() async {
  if(!await isSessionValid()) await refreshSession();

  var request = createRequest('POST', 'v1/devices/delete');
  request.headers.addAll(await getHeader());

  print(request.headers);

  var response = await request.send();

  if (response.statusCode == 200) {
    clearCache();

    print('Successfully delete the current device');

    return true; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return false;
  }
}

Future<Map<String, dynamic>?> updateUsername(String name) async {
  if(!await isSessionValid()) await refreshSession();

  var request = createRequest('POST', 'v1/devices/update/name');
  request.headers.addAll(await getHeader());

  request.body = jsonEncode({
    'name': name
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> body = new Map<String, dynamic>();
    body = jsonDecode(await response.stream.bytesToString());

    return body['data']; ///return response data from api
  } else {
    //Wrong input
    print(response.reasonPhrase);
    return null;
  }
}