class User {
  final int id;
  final String userName;
  final String email;
  // String password;
  final String firstName;
  final String surName;
  final DateTime createdDate;

  const User({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.surName,
    required this.createdDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        userName: json['userName'],
        email: json['email'],
        firstName: json['firstName'],
        surName: json['surName'],
        createdDate: json['createdDate']
    );
  }

  Map<String, dynamic> toJson() {

    return <String, dynamic> {
      'id': id,
      'userName': userName,
      // 'password': password,
      'email': email,
      'firstName': firstName,
      'sunName': surName,
      'createdDate': createdDate
    };
  }
}