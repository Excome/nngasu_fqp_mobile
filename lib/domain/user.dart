import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:nngasu_fqp_mobile/domain/role.dart';


class User {
  late int id;
  String userName;
  String email;
  String firstName = "";
  String surName = "";
  List<Role> roles = [];
  late DateTime createdDate;
  late String pass;
  late String passConfirm;


  User(this.userName, this.email,
      {int? id, String? firstName, String? surName, List<Role>? roles,
        DateTime? createdDate, String? pass, String? passConfirm}){
    this.id = id ?? 0;
    this.firstName = firstName ?? "";
    this.surName = surName ?? "";
    this.roles = roles ?? [];
    this.createdDate = createdDate ?? DateTime.now();
    this.pass = pass ?? "";
    this.passConfirm = passConfirm ?? "";
  }

  factory User.fromJson(Map<String, dynamic> json) {
    var jsonRoles = json['roles'];
    List<Role> roles = [];
    if (jsonRoles != null) {
      for(var role in jsonRoles) {
        roles.add(Role.values.byName(role));
      }
    }
    var createdDate = json['createdDate'];
    if (createdDate != null) {
      createdDate = DateFormat("dd-MM-yyy HH:mm").parse(createdDate);
    } else {
      createdDate = DateTime.now();
    }
    return User(
        json['userName'],
        json['email'],
        id: json['id'],
        firstName: json['firstName'],
        surName: json['surName'],
        roles: roles,
        createdDate: createdDate
    );
  }

  Map<String, dynamic> toJson() {
    List<String> roles = [];
    for (var role in this.roles) {
      roles.add(role.name);
    }
    return <String, dynamic> {
      'id': id,
      'userName': userName,
      'pass': pass,
      'passConfirm': passConfirm,
      'email': email,
      "role": jsonEncode(roles),
      'firstName': firstName,
      'surName': surName,
      'createdDate': createdDate.toString()
    };
  }

  @override
  String toString() {
    return 'User{id: $id, userName: $userName, email: $email, firstName: $firstName, surName: $surName, createdDate: $createdDate, pass: $pass, passConfirm: $passConfirm}';
  }

  @override
  bool operator ==(Object other) =>
      other is User &&
          id == other.id &&
          userName == other.userName &&
          email == other.email &&
          firstName == other.firstName &&
          surName == other.surName;

  @override
  int get hashCode =>
      id.hashCode ^
      userName.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      surName.hashCode ^
      roles.hashCode ^
      createdDate.hashCode ^
      pass.hashCode ^
      passConfirm.hashCode;
}