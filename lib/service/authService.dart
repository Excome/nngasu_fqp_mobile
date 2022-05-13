import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';

import 'httpClient.dart';

class AuthService {
  static Future<User> fetchUser(String userName, String token) async {
    var url = Uri.parse('${Application.serverUrl}/users/$userName');
    var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
    final response = await http.get(url, headers: headersMap);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch user with '$userName' userName.");
    }
  }

  static Future<User> register(User user) async {
    try {
      var requestBody = user.toJson();
      var responseBody = await HttpClient.post('/registration', requestBody);
      return User.fromJson(responseBody);
    } catch (e) {
      Application.logger.w("Exception while user registration: $e");
      return user;
    }
  }

  // Returned string with jwtToken for server auth
  static Future<String> login(String username, String password) async {
    try {
      var requestBody = {"username": username, "password": password};
      final responseBody = await HttpClient.post('/login', requestBody);
      return responseBody['token'];
    } catch (e) {
      Application.logger.e("Failed to login '$username' user: $e");
      return 'failure';
    }
  }
}
