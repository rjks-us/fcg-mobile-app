import 'dart:convert';
import 'package:http/http.dart' as http;

var host = 'https://api.fcg-app.de';

Future<Map<String, dynamic>> getClasses() async {
  return await request("GET", "v1/classes");
}

Future<Map<String, dynamic>> getSignature() async {
  return await request("GET", "signature");
}

Future<Map<String, dynamic>> getVersion() async {
  return await request("GET", "version");
}

Future<Map<String, dynamic>> request(String method, String router) async {
  var request = http.Request(method, Uri.parse(host + '/' + router));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return jsonDecode(await response.stream.bytesToString());
  } else {
    print(response.statusCode);
    return jsonDecode("{}"); //<-- returns empty json object
  }
}