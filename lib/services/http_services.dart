import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _base_url;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
    print(_base_url);
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = "$_base_url$_path";
      // print(_url);
      Response _response = await dio.get(_url);
      print(_response);
      return _response;
    } catch (e) {
      print("Unable to perform a get request");
      print(e);
    }
  }
}
