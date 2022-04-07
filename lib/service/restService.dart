import 'dart:convert';
import 'dart:io';

import 'package:nngasu_fqp_mobile/main.dart';
import 'package:http/http.dart' as http;


class RestService {
  static Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) async{
    var uri = Uri.parse('${Application.serverUrl}/$url');
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      var body = jsonDecode(response.body);
      throw HttpException('Failed to fetch data from url: $uri},'
          '\nerrorCode: ${body['code']},'
          '\nmessage: ${body['message']}');
    }
  }

  static Future<Map<String, dynamic>> post (String url, Map<String, dynamic> requestBody, {Map<String, String>? headers}) async{
    var uri = Uri.parse('${Application.serverUrl}/url')
    final response = await http.post(uri, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var body = jsonDecode(response.body);
      throw HttpException('Failed to execute post request for url: $uri},'
          '\nerrorCode: ${body['code']},'
          '\nmessage: ${body['message']}');
    }

    return null;
  }

// Future<Map<String, dynamic>> put(){}

// Future<Map<String, dynamic>> delete(){}
}