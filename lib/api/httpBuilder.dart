import 'dart:convert';
import 'package:fcg_app/api/helper.dart' as helper;
import 'package:fcg_app/api/sessionCacher.dart';
import 'package:http/http.dart' as http;

Cache httpCache = new Cache(Duration(minutes: 10));

class Request {
  late http.Request httpRequest;

  late bool shouldCache = false, makeNewRequest = true, shouldLoadFromCacheIfPossible = false;

  late String method, router, body;
  late Map<String, String> header;

  Request(String method, String router, bool shouldCacheOnSuccess, bool newRequest, bool shouldLoadFromCacheIfPossible) {
    this.method = method;
    this.router = router;

    if(method == 'GET') {
      this.shouldCache = shouldCacheOnSuccess;
      this.makeNewRequest = newRequest;
      this.shouldLoadFromCacheIfPossible = shouldLoadFromCacheIfPossible;
    }

    this.httpRequest = http.Request(method, Uri.parse(helper.host + '/' + router));
  }

  setHost(String host) async {
    httpRequest = http.Request(this.method, Uri.parse(host + '/' + this.router));
  }

  setHeader(Map<String, String> headers) {
    httpRequest.headers.addAll(headers);
  }

  setBody(Map<String, dynamic> body) {
    httpRequest.body = jsonEncode(body);
  }

  flush() async {
    try {
      return new Response(httpRequest, shouldCache, makeNewRequest, shouldLoadFromCacheIfPossible);
    } catch (_) {
      return new Response(null, shouldCache, makeNewRequest, shouldLoadFromCacheIfPossible);
    }
  }
}

class Response {

  late Map<String, dynamic>? body;

  late bool shouldCache = false, makeNewRequest = true, shouldLoadFromCacheIfPossible = true;

  late bool isInCache = false, errorConnection = false;

  http.Request? request;
  http.StreamedResponse? response;
  late Function(dynamic) noDataReceived, success, unauthorized, pageNotFound, entryCreated, entryDeleted, serverError, invalidRequest, error;

  Response(var request, bool shouldCacheOnSuccess, bool newRequest, bool shouldLoadFromCacheIfPossible) {

    this.shouldCache = shouldCacheOnSuccess;
    this.makeNewRequest = newRequest;
    this.shouldLoadFromCacheIfPossible = shouldLoadFromCacheIfPossible;
    this.request = request;

    if(request == null) return;
  }

  checkCache() async { ///Must be called
    try {
      if(makeNewRequest) {
        print('http-request: ${request!.method} ${request!.url}');
        var tmp = await this.request!.send();
        this.response = tmp;
      } else {
        if(shouldLoadFromCacheIfPossible && httpCache.isSet('${getCacheIdentifier()}') && !makeNewRequest) {
          isInCache = true;
          print('cache load: ${getCacheIdentifier()}');
          this.body = httpCache.get('${request!.url.toString()}');
        } else {
          print('http-request: ${request!.method} ${request!.url}');
          var tmp = await this.request!.send();
          this.response = tmp;
        }
      }
    } catch(_) {
      errorConnection = true;
      print(_);
    }
  }

  onNoResult(var callback) {
    this.noDataReceived = callback;
  }

  onSuccess(var callback) {
    this.success = callback;
  }

  onUnauthorized(var callback) {
    this.unauthorized = callback;
  }

  onPageNotFound(var callback) {
    this.pageNotFound = callback;
  }

  onEntryCreated(var callback) {
    this.entryCreated = callback;
  }

  onEntryDeleted(var callback) {
    this.entryDeleted = callback;
  }

  onServerError(var callback) {
    this.serverError = callback;
  }

  onInvalidRequest(var callback) {
    this.invalidRequest = callback;
  }

  onError(var callback) {
    this.error = callback;
  }

  process() async {
    if(this.request == null || this.errorConnection) {
      return noDataReceived(null);
    }

    if(shouldLoadFromCacheIfPossible && isInCache) {
      var tmp = httpCache.get(getCacheIdentifier());
      return success(tmp!['data']);
    }

    if(!isInCache) this.body = jsonDecode(await this.response!.stream.bytesToString());

    if(this.body == null) { ///No response received
      noDataReceived(null);
      return;
    } else {
      if(body!['data'] is Map<String, dynamic>) { ///Is another json object
        Map<String, dynamic>? data = body!['data'];
        switch(body!['status']) {
          case 200:
            if(shouldCache) httpCache.save('${getCacheIdentifier()}', body);
            success(data);
          break;
          case 201: entryCreated(data); break;
          case 204: entryDeleted(data); break;
          case 400: invalidRequest(data); break;
          case 401: unauthorized(data); break;
          case 404: pageNotFound(data); break;
          case 500: serverError(data); break;
          default: error(this.response);
        }
      } else { ///Is a list
        List<dynamic>? data = body!['data'];
        switch(body!['status']) {
          case 200:
            if(shouldCache) httpCache.save('${getCacheIdentifier()}', body);
            success(data);
            break;
          case 201: entryCreated(data); break;
          case 204: entryDeleted(data); break;
          case 400: invalidRequest(data); break;
          case 401: unauthorized(data); break;
          case 404: pageNotFound(data); break;
          case 500: serverError(data); break;
          default: error(this.response);
        }
      }
      return;
    }
  }

  getStatusCode() {
    return response!.statusCode;
  }

  getCacheIdentifier() {
    return '-${request!.method}-${request!.url}-${request!.headers.toString()}';
  }
}