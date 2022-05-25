import 'dart:io';

import '../domain/user.dart';
import '../main.dart';
import 'httpClient.dart';

class UserService {
  static Future<User> fetchUser(String userName, String token) async {
    try {
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var response = await HttpClient.get("/users/$userName", headers: headersMap);

      return User.fromJson(response);
    } catch (e) {
      Application.logger.e("Failed to fetch user '$userName': $e");
      return User("", "");
    }
  }
}