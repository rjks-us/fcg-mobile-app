import 'dart:convert';
import 'package:http/http.dart' as http;

var host = 'https://api.fcg-app.de';
// var host = 'http://localhost:8080';

Future<Map<String, dynamic>> getClasses() async {
  var respond;
  respond = await request("GET", "classes");

  if(respond.statusCode == 200) return jsonDecode(await respond.stream.bytesToString());

  return jsonDecode('{}');
}

Future<Map<String, dynamic>> getSignature() async {
  var respond;
  respond = await request("GET", "signature");

  if(respond.statusCode == 200) return jsonDecode(await respond.stream.bytesToString());

  return jsonDecode('{}');
}

Future<Map<String, dynamic>?> getVersion() async {
  var respond;
  respond = await request("GET", "version");

  if(respond.statusCode == 200) return jsonDecode(await respond.stream.bytesToString());

  return null;
}

Future<Map<String, dynamic>?> getToday() async {
  var respond;
  respond = await request("GET", "v1/today");

  if(respond.statusCode == 200) return jsonDecode(await respond.stream.bytesToString());

  return null;
}

Future<http.StreamedResponse> request(String method, String router) async {
  var request = http.Request(method, Uri.parse(host + '/' + router));
  var response = await request.send();

  print('http-request: $request');

  return response;

  /*if (response.statusCode == 200) {
    return jsonDecode(await response.stream.bytesToString());
  } else {
    print(response.statusCode);
    return jsonDecode("{}"); //<-- returns empty json object
  }*/
}

http.Request createRequest(String method, String router) {
  var request = http.Request(method, Uri.parse(host + '/' + router));
  return request;
}
