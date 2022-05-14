import 'dart:convert';
import 'dart:io';

import 'package:nngasu_fqp_mobile/main.dart';
import 'package:http/http.dart' as http;


class HttpClient {
  static Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) async{
    var uri = Uri.parse('${Application.serverUrl}/$url');
    var requestHeaders = {HttpHeaders.contentTypeHeader: 'application/json'};
    requestHeaders.addAll(headers!);
    final response = await http.get(uri, headers: requestHeaders);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200){
      return responseBody;
    } else {
      throw HttpException('Failed to fetch data from url: $uri},'
          '\nstatus: ${response.statusCode} ${responseBody['status']},'
          '\nsubCode: ${responseBody['subCode']},'
          '\nmessage: ${responseBody['message']}'
          '\nerrors: ${responseBody['errors']}');
    }
  }

  static Future<Map<String, dynamic>> post (String url, Map<String, dynamic> requestBody, {Map<String, String>? headers}) async{
    var uri = Uri.parse('${Application.serverUrl}$url');
    var requestHeaders = {HttpHeaders.contentTypeHeader: 'application/json'};
    if (headers != null) {
      requestHeaders.addAll(headers);
    }
    Application.logger.d(requestBody);
    final response = await http.post(uri, headers: requestHeaders, body: jsonEncode(requestBody));
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw HttpException('Failed to execute POST request for url: $uri},'
          '\nstatus: ${response.statusCode} ${responseBody['status']},'
          '\nsubCode: ${responseBody['subCode']},'
          '\nmessage: ${responseBody['message']}'
          '\nerrors: ${responseBody['errors']}');
    }
  }

  static Future<Map<String, dynamic>> put(String url, Map<String, dynamic> requestBody, {Map<String, String>? headers}) async {
    var uri = Uri.parse('${Application.serverUrl}$url');
    var requestHeaders = {HttpHeaders.contentTypeHeader: 'application/json'};
    requestHeaders.addAll(headers!);
    final response = await http.put(uri, headers: requestHeaders, body: requestBody);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw HttpException('Failed to execute PUT request for url: $uri,'
          '\nstatus: ${response.statusCode} ${responseBody['status']},'
          '\nsubCode: ${responseBody['subCode']},'
          '\nmessage: ${responseBody['message']}'
          '\nerrors: ${responseBody['errors']}');
    }
  }

  static Future<Map<String, dynamic>> delete(String url, Map<String, dynamic> requestBody, {Map<String, String>? headers}) async {
    var uri = Uri.parse('${Application.serverUrl}$url');
    var requestHeaders = {HttpHeaders.contentTypeHeader: 'application/json'};
    requestHeaders.addAll(headers!);
    final response = await http.delete(uri, headers: requestHeaders, body: requestBody);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw HttpException('Failed to execute DELETE request for url: $uri,'
          '\nstatus: ${response.statusCode} ${responseBody['status']},'
          '\nsubCode: ${responseBody['subCode']},'
          '\nmessage: ${responseBody['message']}'
          '\nerrors: ${responseBody['errors']}');
    }
  }
}