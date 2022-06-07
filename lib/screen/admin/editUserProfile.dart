import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:nngasu_fqp_mobile/component/confirmDialog.dart';
import 'package:nngasu_fqp_mobile/domain/role.dart';
import 'package:nngasu_fqp_mobile/screen/home.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

import '../../domain/user.dart';
import '../../main.dart';

class EditUserProfile extends StatefulWidget {
  EditUserProfile({Key? key, required this.user}) : super(key: key);
  User user;
  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _surNameCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  List<String> _selectedRoles = [];
  User _user = User("", "");
  @override
  void initState() {
    _user = widget.user;
    _usernameCtrl.text = _user.userName;
    _emailCtrl.text = _user.email;
    _firstNameCtrl.text = _user.firstName;
    _surNameCtrl.text = _user.surName;
    _passCtrl.text = _user.pass;
    _selectedRoles = _user.roles.map((role) => role.translation).toList();
  }

  Widget _textBox(String text, String placeholder, Icon icon,
      TextEditingController controller, bool enabled) {
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

  Widget _roleDropDownList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropDownMultiSelect(
        // isDense: true,
        onChanged: (List<String> x) {
          setState(() {
            _selectedRoles = x;
          });
        },
        options: Role.values.map((role) => role.translation).toList(),
        selectedValues: _selectedRoles,
        whenEmpty: 'Роли пользователя',
      ),
    );
  }

  Widget _menuButton(String text, void Function() func, Color textColor) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width / 2.2, 50),
            elevation: 0,
            primary: Colors.white),
        onPressed: func,
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_user.userName),
          backgroundColor: Application.nngasuOrangeColor
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: _textBox(_user.userName, "Имя пользователя",
                  const Icon(Icons.person), _usernameCtrl, false),
            ),
            _roleDropDownList(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: _textBox(_user.email, "Email",
                  const Icon(Icons.email), _emailCtrl, true),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: _textBox(_user.firstName, "Имя",
                  const Icon(Icons.arrow_drop_up_sharp), _firstNameCtrl, true),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: _textBox(_user.surName, "Фамилия",
                  const Icon(Icons.arrow_drop_up_sharp), _surNameCtrl, true),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: _textBox(_user.pass, "Пароль",
                  const Icon(Icons.arrow_drop_up_sharp), _passCtrl, true),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Visibility(
                      visible: Application.crrUser.hasPriorityMoreThen(Role.ROLE_ADMIN),
                      child: _menuButton("Удалить", () { showDialog(context: context, builder: (context) {return ConfirmDialog(
                        title: "Удалить",
                        description: "Данное действие удалит все заявки пользователя! Вы уверены что хотите удалить пользователя '${_user.userName}'?",
                        leftButtonText: "Отмена",
                        lbOnPressed: () { Navigator.of(context).pop(); },
                        rightButtonText: "Удалить",
                        rbOnPressed: deleteUserByAdmin,
                      );});} , Colors.red)),
                    ) ,
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: _menuButton("Изменить", editUserByAdmin, Application.nngasuBlueColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void editUserByAdmin() async {
    _user.userName = _usernameCtrl.text.trim();
    _user.email = _emailCtrl.text.trim();
    _user.firstName = _firstNameCtrl.text.trim();
    _user.surName = _surNameCtrl.text.trim();
    _user.pass = _passCtrl.text;
    List<Role> roles = [];
    for (var strRole in _selectedRoles){
      roles.add(Role.values.singleWhere((role) => role.translation == strRole));
    }
    _user.roles = roles;
    var response = await UserService.editUserByAdmin(_user, Application.token);
    if (response.id != 0) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(pageIndex: 2)), (route) => false);
    }
  }

  void deleteUserByAdmin() async {
    var userName = _user.userName;
    var result = await UserService.deleteUserByAdmin(userName, Application.token);
    if (result) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(pageIndex: 2)), (route) => false);
    }

  }
}
