import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/userDetail.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

import '../domain/role.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ScrollController _scrollController = ScrollController();
  final List<User> _users = [];
  int _page = 0;
  bool _isLoading = true;

  @override
  void initState() {
    fetchUsers(_page);
    _scrollController.addListener(pagination);
  }

  @override
  Widget build(BuildContext context) {
    var usersListBuilder = Expanded(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  alignment: Alignment.center,
                  width: 50,
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(_users[index].id.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Application.nngasuBlueColor)),
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            width: 1,
                            color: Application.nngasuOrangeColor)),
                  ),
                ),
                title: Text(_getHighPriorityRole(_users[index].roles), style: TextStyle(color: roleColors(_getHighPriorityRole(_users[index].roles)), fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(_users[index].userName, style: const TextStyle(color: Colors.black, fontSize: 20)),
                    Text("${_users[index].surName} ${_users[index].firstName}", style: const TextStyle(color: Application.nngasuBlueColor, fontSize: 14)),
                  ],
                ),
                  onTap: () {
                    if (Application.crrUser.hasPriorityMoreThen(Role.ROLE_MODERATOR)) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              UserDetail(user: _users[index])));
                    }
                  },
                ),
            );
          }
        )
    );

    return Column(
      children: <Widget>[usersListBuilder],
    );
  }

  void fetchUsers(int page) async {
    var users = await UserService.fetchUsers(page, Application.token);
    if (users.isNotEmpty){
      _page += 1;
      setState(() => _users.addAll(users));
    } else {
      _isLoading = false;
    }
  }

  String _getHighPriorityRole(List<Role> roles) {
    var maxRole = Role.ROLE_GUEST;
    for (var role in roles) {
      if (role.priority > maxRole.priority){
        maxRole = role;
      }
    }
    return maxRole.translation;
  }

  void pagination() {
    if (_scrollController.position.extentAfter <= 0 && _isLoading) {
      fetchUsers(_page);
    }
  }
  
  Color roleColors(String role) {
    switch (role) {
      case "Преподаватель":
        return Application.nngasuBlueColor;
      case "Техник":
        return Colors.green;
      case "Модератор":
        return Colors.purple;
      case "Администратор":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
