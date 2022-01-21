import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
String _apiHost = "https://fcg-app.de";

void init (String host) {
  _apiHost = host;
}

class Request {

  String router, method;
  late http.Request httpRequest;

  Request(this.method, this.router) {
    // this.httpRequest = http.Request(method, Uri.parse("http://localhost:8080" + '/' + router));
    this.httpRequest = http.Request(method, Uri.parse("https://api.fcg-app.de" + '/' + router));
  }

  setHost(String host) async {
    httpRequest = http.Request(this.method, Uri.parse("https://api.fcg-app.de" + '/' + this.router));
    // httpRequest = http.Request(this.method, Uri.parse("http://localhost:8080" + '/' + this.router));
  }

  setHeader(Map<String, String> headers) {
    httpRequest.headers.addAll(headers);
  }

  setBody(Map<String, dynamic> body) {
    httpRequest.body = jsonEncode(body);
  }

  Map<String, String> buildAccessHeader(String token) {
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    return header;
  }

  Response send() {
    return new Response(this.httpRequest);
  }
}

class Response {

  late http.Request httpRequest;
  late http.StreamedResponse httpResponse;

  Map<String, dynamic> body = new Map();
  bool invalidRequest = false;
  
  late Function(dynamic) success, error, notFound, unauthorized, noDataReceived;

  Response(this.httpRequest);

  Future<void> processResponse() async {
    try {

      print('[API] http-request: ${httpRequest.method}: ${httpRequest.url}');
      // print(httpRequest.headers);
      // print(httpRequest.body);

      var response =  await this.httpRequest.send();

      this.httpResponse = response;

      this.body = jsonDecode(await this.httpResponse.stream.bytesToString());
    } catch (_) {
      print(_);
      invalidRequest = true;
    }
  }

  void onSuccess(var callback) {
    this.success = callback;
  }

  void onError(var callback) {
    this.error = callback;
  }

  void onUnauthorized(var callback) {
    this.unauthorized = callback;
  }

  void onPageNotFound(var callback) {
    this.notFound = callback;
  }

  onNoResult(var callback) {
    this.noDataReceived = callback;
  }

  void registerListeners() {

    if(this.invalidRequest) {
      return error('Error while sending request');
    }

    if(this.body.isEmpty || this.body['data'] == null) return notFound(this.body);

    if(this.body['data'] is Map<String, dynamic>) {
      Map<String, dynamic> data = body['data'];

      switch(getStatusCode()) {
        case 200: success(data); break;
        case 201: success(data); break;
        case 401: unauthorized(data); break;
        case 404: notFound(data); break;
        case 500: error(data); break;
        default: error(this.httpResponse); break;
      }
    } else {
      List<dynamic> data = body['data'];

      switch(getStatusCode()) {
        case 200: success(data); break;
        case 201: success(data); break;
        case 401: unauthorized(data); break;
        case 404: notFound(data); break;
        case 500: error(data); break;
        default: error(this.httpResponse); break;
      }
    }
    return;
  }

  int getStatusCode() {
    return (invalidRequest) ? 500 : this.httpResponse.statusCode;
  }

  String getIdentifier() {
    return '-${httpRequest.method}-${httpRequest.url}-${httpRequest.headers.toString()}';
  }
}

Future<bool> deviceIsConnectedToInternet() async {
  try {
    var request = http.Request('GET', Uri.parse('https://api.fcg-app.de'));
    var response = await request.send();

    print('http-request: $request');

    print(response.statusCode);

    return true;
  } catch(_) {
    print(_);
    return false;
  }
}