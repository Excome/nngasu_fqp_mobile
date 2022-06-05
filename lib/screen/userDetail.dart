import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

class UserDetail extends StatefulWidget {
  UserDetail({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  User _user = User("", "");

  @override
  void initState() {
    fetchUser(widget.user.userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_user.userName),
          backgroundColor: Application.nngasuOrangeColor
      ),
    );
  }

  void fetchUser(String userName) async {
    var user = await UserService.fetchUser(userName, Application.token);
    if (user.userName.isNotEmpty){
      setState(() => _user = user);
    }
  }
}
