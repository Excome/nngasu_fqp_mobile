import 'dart:convert';
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

  static Future<List<User>> fetchUsers(int page, String token) async {
    try {
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var responseBody = await HttpClient.get("/users?&page=$page", headers: headersMap);

      List<User> userList = [];
      for (var userJson in responseBody) {
        userList.add(User.fromJson(userJson));
      }

      return userList;
    } catch (e) {
      Application.logger.e("Failed to fetch users at '$page' page: $e");
      return <User>[];
    }
  }

  static Future<User> editUserProfile(User user, String token) async {
    try {
      var userName = user.userName;
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var requestBody = user.toJson();
      var response = await HttpClient.put("/users/$userName", requestBody, headers: headersMap);

      return User.fromJson(response);
    } catch (e) {
      Application.logger.e("Failed to edit user '${user.userName}' profile: $e");
      return User("", "");
    }
  }

  static Future<List<User>> fetchResponsibleUsers(String token) async {
    try {
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var response = await HttpClient.get("/responsible-users", headers: headersMap);
      var usersList = <User> [];
      for (var item in response) {
        usersList.add(User.fromJson(item));
      }
      return usersList;
    } catch (e) {
      Application.logger.e("Failed to fetch list of responsible users': $e");
      return [];
    }
  }

  static Future<User> editUserByAdmin(User user, String token) async {
    try {
      var userName = user.userName;
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var requestBody = user.toJson();
      var response = await HttpClient.put("/admin/users/$userName", requestBody, headers: headersMap);

      return User.fromJson(response);
    } catch (e) {
      Application.logger.e("Failed to edit user '${user.userName}' by admin '${Application.crrUsername}': $e");
      return User("", "");
    }
  }

  static Future<bool> deleteUserByAdmin(String userName, String token) async {
    try {
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var requestBody = <String, dynamic> {};
      var response = await HttpClient.delete("/admin/users/$userName",requestBody, headers: headersMap);

      return true;
    } catch (e) {
      Application.logger.e("Failed to delete user '$userName' by admin '${Application.crrUsername}': $e");
      return false;
    }
  }
}