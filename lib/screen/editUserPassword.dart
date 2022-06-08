import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

import '../domain/user.dart';
import '../main.dart';

class EditUserPass extends StatefulWidget {
  const EditUserPass({Key? key}) : super(key: key);

  @override
  State<EditUserPass> createState() => _EditUserPassState();
}

class _EditUserPassState extends State<EditUserPass> {
  final TextEditingController _passCntrl = TextEditingController();
  final TextEditingController _passConfCntrl = TextEditingController();
  bool isError = false;

  Widget _textBox(String placeholder, Icon icon,
      TextEditingController controller, bool enabled) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        enabled: enabled,
        obscureText: true,
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

  Widget _menuButton(
      String text, void Function() func, Color textColor, double width) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, 50), elevation: 0, primary: Colors.white),
        onPressed: func,
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Application.nngasuOrangeColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        title: const Text('ННГАСУ | ТРО'),
        // leading: const Icon(Icons.home_rounded),
        backgroundColor: Application.nngasuOrangeColor,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _textBox(
                "Пароль", const Icon(Icons.lock), _passCntrl, true),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _textBox("Подтверждение пароля",
                const Icon(Icons.password), _passConfCntrl, true),
          ),
          Visibility(
              visible: isError,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Введеные пароли не совпадают!",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )),
          Row(
            children: <Widget>[
              _menuButton(
                  "Отмена", () => Navigator.of(context).pop(), Colors.red, 180),
              _menuButton(
                  "Изменить", changeUserPass, Application.nngasuBlueColor, 180)
            ],
          )
        ],
      ),
    );
  }

  void changeUserPass() async {
    var pass = _passCntrl.text.trim();
    var passConf = _passConfCntrl.text.trim();
    if (pass == passConf){
      var user = User(Application.crrUsername, "");
      user.pass = pass;
      user.passConfirm = passConf;
      var response = await UserService.editUserPass(user, Application.token);
      if (response.userName == Application.crrUsername){
        setState(() => Navigator.of(context).pop());
      } else {
        setState(() => isError = true);
      }
    } else {
      setState(() => isError = true);
    }
  }
}
