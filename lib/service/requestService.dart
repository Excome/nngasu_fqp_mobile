import 'dart:io';

import 'package:nngasu_fqp_mobile/domain/request.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/service/httpClient.dart';

import '../main.dart';

class RequestService {

  static Future<List<Request>> fetchRequests(int page, String token) async {
    try {
      var url = '/requests?page=$page';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var responseBody = await HttpClient.get(url, headers: headersMap);
      List<Request> requests = [];
      for (var request in responseBody){
        requests.add(Request.fromJson(request));
      }
      return requests;
    } catch (e) {
      Application.logger.w("Failed to fetch requests at page '$page': $e");
      return [];
    }
  }

  static Future<List<Request>> fetchUserRequests(int page, String? userName, String token) async {
    try {
      var url = '/requests?author=$userName&page=$page';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var responseBody = await HttpClient.get(url, headers: headersMap);
      List<Request> requests = [];
      for (var request in responseBody){
        requests.add(Request.fromJson(request));
      }
      return requests;
    } catch (e) {
      Application.logger.w("Failed to fetch requests at page '$page': $e");
      return [];
    }
  }

  static Future<Request> fetchRequest(int id, String token) async {
    try {
      var url = '/requests/$id';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var responseBody = await HttpClient.get(url, headers: headersMap);
      return Request.fromJson(responseBody);
    } catch (e) {
      Application.logger.w("Failed to fetch request with '$id' id: $e");
      return Request(User("",""), "", []);
    }
  }

  static Future<Request> createRequest(Request request, String token) async {
    try {
      var url = '/requests';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var requestBody = request.toJson();
      var responseBody = await HttpClient.post(url, requestBody, headers: headersMap);
      return Request.fromJson(responseBody);
    } catch (e) {
      Application.logger.w("Failed to create request with '$request' id: $e");
      return Request(User("",""), "", []);
    }
  }
}