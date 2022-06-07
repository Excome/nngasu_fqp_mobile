import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/admin/editUserProfile.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

import '../component/request-list.dart';
import '../domain/role.dart';

class UserDetail extends StatefulWidget {
  UserDetail({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _roleCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _surNameCtrl = TextEditingController();
  final TextEditingController _createdDateCtrl = TextEditingController();
  User _user = User("", "");

  @override
  void initState() {
    fetchUser(widget.user.userName);
  }

  Widget _textBox(String text, String placeholder, Icon icon,
      TextEditingController controller, bool enabled) {
    controller.text = text;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        enabled: enabled,
        controller: controller,
        style: const TextStyle(fontSize: 20, color: Colors.black),
        decoration: InputDecoration(
            hintStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
            // hintText: placeholder,
            labelText: placeholder,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(239, 103, 0, 0.8), width: 2)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(239, 103, 0, 0.3), width: 2)),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data:
                const IconThemeData(color: Color.fromRGBO(239, 103, 0, 1)),
                child: icon,
              ),
            )),
      ),
    );
  }

  Widget _menuButton(String text, void Function() func, Color textColor) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 50),
            elevation: 0,
            primary: Colors.white),
        onPressed: func,
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)));
  }

  Dialog _createdRequestsDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 16,
        child: RequestList(author: _user.userName));
  }

  Dialog _responsibleRequestsDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 16,
        child: RequestList(responsible: _user.userName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_user.userName),
          backgroundColor: Application.nngasuOrangeColor,
          actions: [
            Visibility(
              visible: Application.crrUser.hasPriorityMoreThen(Role.ROLE_MODERATOR),
                child: IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditUserProfile(user: _user))),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  tooltip: "Изменить профиль пользователя",
              )
            )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: _textBox(_user.userName, "Имя пользователя",
                  const Icon(Icons.person), _usernameCtrl, false),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: _textBox(_user.email, "Email",
                  const Icon(Icons.email), _emailCtrl, false),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _textBox(_getHighPriorityRole(_user.roles), "Права доступа",
                  const Icon(Icons.admin_panel_settings_sharp), _roleCtrl, false),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: _textBox(_user.firstName, "Имя",
                  const Icon(Icons.arrow_drop_up_sharp), _firstNameCtrl, false),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: _textBox(_user.surName, "Фамилия",
                  const Icon(Icons.arrow_drop_up_sharp), _surNameCtrl, false),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: _textBox(DateFormat("dd-MM-yyy HH:mm").format(_user.createdDate), "Дата регистрации",
                  const Icon(Icons.date_range), _createdDateCtrl, false),
            ),
            Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: true,
                    child: _menuButton("Созданные заявки", () {
                      showDialog(context: context, builder: (context) => _createdRequestsDialog(context));
                    }, Application.nngasuOrangeColor)
                )
            ),
            Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: _user.roles.contains(Role.ROLE_ADMIN) || _user.roles.contains(Role.ROLE_TECHNICIAN),
                    child: _menuButton("Ответственные заявки", () {
                      showDialog(context: context, builder: (context) => _responsibleRequestsDialog(context));
                    }, Application.nngasuOrangeColor)
                )
            )
          ],
        ),
      ),
    );
  }

  void fetchUser(String userName) async {
    var user = await UserService.fetchUser(userName, Application.token);
    if (user.userName.isNotEmpty){
      setState(() => _user = user);
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
}
