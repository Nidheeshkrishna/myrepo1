import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum RequestType { GET, POST, PUT, DELETE }

class DataService {
  Dio client;

  static DataService _instance;

  factory DataService() {
    if (_instance == null) {
      _instance = new DataService._private();
    }
    return _instance;
  }

  DataService._private();

  void init() {
    if (client != null) return;
    BaseOptions options = BaseOptions(baseUrl: 'https://api.github.com/orgs/');
    this.client = Dio(options);
  }

  Future<Response<dynamic>> request(
      {@required RequestType requestType,
      dynamic data,
      @required String endpoint}) async {
    init();

    Response _response;
    try {
      switch (requestType) {
        case RequestType.GET:
          _response = await client.get(endpoint);
          break;
        case RequestType.POST:
          _response = await client.post(endpoint, data: data);
          print(_response.data);
          break;
        case RequestType.PUT:
          _response = await client.put(endpoint, data: data);
          break;
        case RequestType.DELETE:
          _response = await client.delete(endpoint);
          break;
        default:
          break;
      }
    } on DioError catch (e) {
      _response = e.response;
    }

    return _response;
  }

  void setHeaders(Map<String, dynamic> headers) {
    this.client.options.headers = headers;
  }
}
