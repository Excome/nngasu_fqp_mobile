import 'package:nngasu_fqp_mobile/domain/user.dart';

import 'equipment.dart';

class Request {
  late int id;
  User author;
  User responsible;
  List<Equipment> equipment;
  String audience;
  String description;
  bool status;

  Request(this.id, this.author, this.responsible, this.equipment, this.audience,
      this.description, this.status);
}