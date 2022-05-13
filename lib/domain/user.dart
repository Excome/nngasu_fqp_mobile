import 'package:intl/intl.dart';


class User {
  late int id;
  String userName;
  String email;
  String firstName;
  String surName;
  // List<String> roles;
  late DateTime createdDate;
  late String pass;
  late String passConfirm;


  User(this.userName, this.email, this.firstName, this.surName);

  User.withId(this.id, this.userName, this.email, this.firstName, this.surName, this.createdDate) {
   pass = "";
   passConfirm = "";
  }

  User.forRegister(this.userName, this.email, this.firstName, this.surName, this.pass, this.passConfirm) {
    id = 0;
    createdDate = DateTime.now();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User.withId(
        json['id'],
        json['userName'],
        json['email'],
        json['firstName'],
        json['surName'],
        DateFormat("dd-MM-yyy HH:mm").parse(json['createdDate'])
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic> {
      'id': id,
      'userName': userName,
      'pass': pass,
      'passConfirm': passConfirm,
      'email': email,
      'firstName': firstName,
      'sunName': surName,
      'createdDate': createdDate.toString()
    };
  }

  @override
  String toString() {
    return 'User{id: $id, userName: $userName, email: $email, firstName: $firstName, surName: $surName, createdDate: $createdDate, pass: $pass, passConfirm: $passConfirm}';
  }
}