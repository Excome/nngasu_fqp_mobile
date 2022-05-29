import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/component/request-list.dart';
import 'package:nngasu_fqp_mobile/screen/authentication.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

import '../domain/user.dart';
import '../main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _surNameCtrl = TextEditingController();
  bool isEditMode = false;
  bool isError = false;
  User crrUser = User("", "");

  @override
  void initState() {
    _fetchUser();
    super.initState();
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
            fixedSize: const Size(180, 50),
            elevation: 0,
            primary: Colors.white),
        onPressed: func,
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)));
  }

  Widget _logoutButton(String text) {
    return Visibility(
        visible: !isEditMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              splashColor: Theme.of(context).primaryColor,
              // highlightColor: Theme.of(context).primaryColor,
              elevation: 0,
              color: Colors.white,
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return _exitDialog(context);
                    });
              },
            ),
          ),
        ));
  }

  Dialog _myRequestsDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 16,
      child: RequestList(userName: crrUser.userName));
  }

  Dialog _exitDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: SizedBox(
        height: 175,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: <Widget>[
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Выход",
                            style:
                                TextStyle(color: Colors.red, fontSize: 18)))),
                const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Вы уверены что хотите выйти? Данный сессии будут удалены",
                            style: TextStyle(
                                color: Colors.black45, fontSize: 16)))),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 100),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Отмена",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54))),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.white),
                          onPressed: _logout,
                          child: const Text("Выйти",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _errorMessage(String text) {
    return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.red),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: !isEditMode,
                    child: _menuButton(
                        "Мои заявки", () { showDialog(
                        context: context,
                        builder: (context) {
                          return _myRequestsDialog(context);
                        }); }, Application.nngasuOrangeColor))),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: !isEditMode,
                    child: _menuButton("Изменить профиль", () {
                      setState(() {
                        isEditMode = true;
                      });
                    }, Application.nngasuOrangeColor))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _textBox(crrUser.userName, "Имя пользователя",
              const Icon(Icons.person), _usernameCtrl, false),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: _textBox(crrUser.email, "Email", const Icon(Icons.email),
              _emailCtrl, isEditMode),
        ),
        Visibility(
            visible: isError,
            child: _errorMessage(
                "Данный адресс электронной почты уже зарегистрирован!")),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: _textBox(
              crrUser.firstName,
              "Имя",
              const Icon(Icons.arrow_drop_up_sharp),
              _firstNameCtrl,
              isEditMode),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: _textBox(crrUser.surName, "Фамилия",
              const Icon(Icons.arrow_drop_up_sharp), _surNameCtrl, isEditMode),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: isEditMode,
                    child: _menuButton("Отмена", () {
                      setState(() {
                        isEditMode = false;
                        isError = false;
                      });
                    }, Colors.red))),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: isEditMode,
                    child: _menuButton("Изменить", _editUserProfile,
                        Application.nngasuBlueColor))),
          ],
        ),
        _logoutButton("Выйти")
      ],
    ));
  }

  void _fetchUser() async {
    var crrUserMap = await Application.db
        .collection('crrUser')
        .doc(Application.dbCrrUserId)
        .get();
    if (crrUserMap != null && crrUserMap.isNotEmpty) {
      crrUser = User.fromJson(crrUserMap);
    } else {
      var user = await UserService.fetchUser(
          Application.crrUsername, Application.token);
      crrUser = user;
      crrUserMap = user.toJson();
      Application.db
          .collection("crrUser")
          .doc(Application.dbCrrUserId)
          .set(crrUserMap);
    }
    setState(() {});
  }

  void _editUserProfile() async {
    var email = _emailCtrl.text.trim();
    var firstName = _firstNameCtrl.text.trim();
    var surName = _surNameCtrl.text.trim();
    crrUser.email = email;
    crrUser.firstName = firstName;
    crrUser.surName = surName;
    var editedUser =
        await UserService.editUserProfile(crrUser, Application.token);
    setState(() {
      if (editedUser.userName.isNotEmpty) {
        crrUser = editedUser;
        Application.db
            .collection("crrUser")
            .doc(Application.dbCrrUserId)
            .set(crrUser.toJson());
        isEditMode = false;
        isError = false;
      } else {
        isError = true;
      }

    });

  }

  void _logout() async {
    var authMap =
        await Application.db.collection('auth').doc(Application.dbAuthId).get();
    if (authMap != null) {
      authMap['token'] = "";
      authMap['userName'] = "";
      Application.db.collection("auth").doc(Application.dbAuthId).set(authMap);
      Application.db.collection("crrUser").doc(Application.dbCrrUserId).set({});
      Application.token = '';
      Application.crrUsername = "";

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthPage()));
    }
  }
}
