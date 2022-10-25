import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';


var token="5|vFUwavpCbXFZaZd4XQDP2UyT2dcIVmJboDdxT4Ax";

Future getApi(String endPoint) async {

  Uri url = Uri.parse("${AppConfig.BASE_URL_1}/$endPoint");
  print("requent url: $url");
  final response = await http.get(url, headers: {
    "Content-Type": "application/json", "Authorization": "Bearer $token",
    "App-Language": app_language.$
  });
  print(url);
  var jsonResponse = json.decode(response.body);
  print("GET Response: $jsonResponse");
  return await jsonResponse;
}