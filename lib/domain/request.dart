import 'package:nngasu_fqp_mobile/domain/user.dart';

import 'equipment.dart';

class Request {
  late int id;
  User author;
  late User responsible;
  List<Equipment> equipment;
  String audience;
  late String description;
  late bool status;

  Request(this.author, this.audience, this.equipment,
      {int? id, User? responsible, String? description, bool? status}) {
    this.id = id ?? 0;
    this.responsible = responsible ?? User("", "");
    this.status = status ?? false;
    this.description = description ?? "";
  }

  factory Request.fromJson(Map<String, dynamic> json) {
    var author = User.fromJson(json['author']);
    var responsible = json['responsible'] != null ? User.fromJson(json['responsible'] ) : null;
    var equipmentsJson = json['equipment'];
    List<Equipment> equipments = [];
    if (equipmentsJson != null) {
      for (var equipment in equipmentsJson) {
        equipments.add(Equipment.fromJson(equipment));
      }
    }
    return Request(author, json['audience'], equipments,
        id: json['id'],
        responsible: responsible,
        description: json['description'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> equipmentJson = [];
    if (equipment.isNotEmpty) {
      for (var tmp in equipment) {
        equipmentJson.add(tmp.toJson());
      }
    }
    return {
      "id": id,
      "author": author.toJson(),
      "responsible": responsible.userName.isEmpty ? null : responsible,
      "equipment": equipmentJson,
      "audience": audience,
      "description": description,
      "status": status
    };
  }
}
