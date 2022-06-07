import 'dart:ffi';
import 'dart:io';

import 'package:nngasu_fqp_mobile/domain/equipment.dart';
import 'package:nngasu_fqp_mobile/service/httpClient.dart';

import '../main.dart';

class EquipmentService {
  static Future<List<Equipment>> fetchEquipments(int page, String token, {int? size}) async {
    try {
      size ??= 10;
      var url = '/equipments?page=$page&size=$size';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var responseBody = await HttpClient.get(url, headers: headersMap);
      List<Equipment> equipments = [];
      for (var equipment in responseBody){
        equipments.add(Equipment.fromJson(equipment));
      }
      return equipments;
    } catch (e) {
      Application.logger.w("Failed to fetch equipments at page '$page': $e");
      return [];
    }
  }

  static Future<Equipment> fetchEquipment(String name, String token) async {
    try {
      var url = '/equipments/$name';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var responseBody = await HttpClient.get(url, headers: headersMap);
      return Equipment.fromJson(responseBody);
    } catch (e) {
      Application.logger.w("Failed to fetch equipment with '$name' name: $e");
      return Equipment("", 0, "", "");
    }
  }

  static Future<Equipment> editEquipment(String name, Equipment equipment, String token) async {
    try {
      var url = '/equipments/$name';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var requestBody = equipment.toJson();
      var responseBody = await HttpClient.put(url, requestBody, headers: headersMap);
      return Equipment.fromJson(responseBody);
    } catch (e) {
      Application.logger.w("Failed to edit equipment with '$name' name: $e");
      return Equipment("", 0, "", "");
    }
  }

  static Future<Equipment> createEquipment(Equipment equipment, String token) async {
    try {
      var url = '/equipments';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var requestBody = equipment.toJson();
      var responseBody = await HttpClient.post(url, requestBody, headers: headersMap);
      return Equipment.fromJson(responseBody);
    } catch (e) {
      Application.logger.w("Failed to create equipment with '${equipment.name}' name: $e");
      return Equipment("", 0, "", "");
    }
  }

  static Future<bool> deleteEquipment(Equipment equipment, String token) async {
    try {
      var url = '/equipments/${equipment.name}';
      var headersMap = {HttpHeaders.authorizationHeader: 'Bearer $token'};
      var requestBody = equipment.toJson();
      await HttpClient.delete(url, requestBody, headers: headersMap);
      return true;
    } catch (e) {
      Application.logger.w("Failed to delete equipment with '${equipment.name}' name: $e");
      return false;
    }
  }
}