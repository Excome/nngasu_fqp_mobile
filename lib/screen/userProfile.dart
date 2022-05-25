import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  User crrUser = User("", "");

  @override
  void initState() {
    _fetchUser();
    super.initState();
  }

  Widget _textBox(String text, String placeholder, Icon icon,
      TextEditingController controller) {
    controller.text = text;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        enabled: isEditMode,
        controller: controller,
        style: const TextStyle(fontSize: 20, color: Colors.black),
        decoration: InputDecoration(
            hintStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
            hintText: placeholder,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(0, 69, 136, 0.8), width: 4)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(0, 69, 136, 0.5), width: 4)),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: const IconThemeData(color: Color.fromRGBO(239, 103, 0, 1)),
                child: icon,
              ),
            )),
      ),
    );
  }

  Widget _logoutButton(String text) {
    return Padding(
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
            /*showDialog(context: context, builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 16,
                child: Container(
                  height: 100,
                  child: Column(
                    children: const <Widget>[
                      Align(alignment: Alignment.topLeft, child: Text("Выход")),
                      Align(alignment: Alignment.bottomRight, child: Text("Отмена")),
                      Align(alignment: Alignment.bottomRight, child: Text("Выход"))
                    ],
                  ),
                ),
              );
            });*/
            var authMap = await Application.db.collection('auth').doc(Application.dbAuthId).get();
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
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: _textBox(crrUser.userName, "Имя пользователя", const Icon(Icons.person), _usernameCtrl),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: _textBox(crrUser.email, "Email", const Icon(Icons.email), _emailCtrl),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: _textBox(crrUser.surName, "Фамилия", const Icon(Icons.arrow_drop_up_sharp), _surNameCtrl),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 250),
          child: _textBox(crrUser.firstName, "Имя", const Icon(Icons.arrow_drop_up_sharp), _firstNameCtrl),
        ),
        _logoutButton("Выйти")
      ],
    );
  }

  void _fetchUser() async {
    var crrUserMap = await Application.db.collection('crrUser').doc(Application.dbCrrUserId).get();
    if (crrUserMap != null && crrUserMap.isNotEmpty) {
      crrUser = User.fromJson(crrUserMap);
    } else {
      var user = await UserService.fetchUser(Application.crrUsername, Application.token);
      crrUser = user;
      crrUserMap = user.toJson();
      Application.db.collection("crrUser").doc(Application.dbCrrUserId).set(crrUserMap);
    }
    setState(() {});
  }
}
