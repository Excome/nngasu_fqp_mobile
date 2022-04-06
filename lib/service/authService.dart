import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';

class AuthService {
  Future<User> fetchUser(String userName, String token) async{
    var url = Uri.parse('${Application.serverUrl}/users/$userName');
    var headersMap = {HttpHeaders.authorizationHeader:'Bearer $token'};
    final response = await http.get(url, headers: headersMap);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch user with '$userName' userName.");
    }
  }

  Future<User> registerUser(User user) async {
    final response = await http.post(
        Uri.parse('${Application.serverUrl}/registration'),
        body: user.toJson()
    );

    if (response.statusCode == 200){
      return User.fromJson(jsonDecode(response.body));
    } else {
      // var responseBody = jsonDecode(response.body);
      throw Exception("Failed to register user '${user.userName}': ");
    }
  }

  // Returned string with jwtToken for server auth
  Future<String> loginUser(User user) async {
    final response = await http.post(
      Uri.parse('${Application.serverUrl}/login'),
      body: user.toJson()
    );

    if (response.statusCode == 200){
      var body = jsonDecode(response.body);
      return body['token'].toString();
    } else {
      throw Exception("Failed to login user '${user.userName}'");
    }
  }
}