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
}