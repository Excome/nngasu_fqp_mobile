import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _ipCntrl = TextEditingController();
  final TextEditingController _portCntrl = TextEditingController();

  @override
  void initState() {
    var urlList = Application.serverUrl.substring(7).split(":");
    _ipCntrl.text = urlList[0];
    _portCntrl.text = urlList[1];
  }

  Widget _textBox(String placeholder, Icon icon,
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

  Widget _menuButton(String text, void Function() func, Color textColor, double width) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(width, 50),
            elevation: 0,
            primary: Colors.white),
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
        children: <Widget> [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: _textBox("IP-адресс", const Icon(Icons.network_wifi), _ipCntrl, true),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: _textBox("Порт сервера", const Icon(Icons.portable_wifi_off_outlined), _portCntrl, true),
          ),
          Row(
            children: <Widget>[
              _menuButton("Отмена", () => Navigator.of(context).pop(), Colors.red, 180),
              _menuButton("Изменить", changeServerUrl, Application.nngasuBlueColor, 180)
            ],
          )
        ],
      ),
    );
  }

  void changeServerUrl() async {
    var ip = _ipCntrl.text.trim();
    var port = _portCntrl.text.trim();
    var authMap = await Application.db.collection("auth").doc(Application.dbAuthId).get();
    if (authMap != null) {
      authMap["serverUrl"] = "http://$ip:$port";
    }
    setState(() => Application.serverUrl = "http://$ip:$port");
  }
}
