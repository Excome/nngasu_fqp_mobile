import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nngasu_fqp_mobile/screen/authentication.dart';
import 'package:nngasu_fqp_mobile/screen/home.dart';

import 'domain/user.dart';

void main() =>  runApp(const Application());

class Application extends StatelessWidget{
  const Application({Key? key}) : super(key: key);
  static const String serverUrl = 'http://192.168.0.198:8080';
  // static const String serverUrl = 'http://195.122.251.100:8080';
  static Logger logger = Logger();
  static Color nngasuBlueColor = const Color.fromRGBO(0, 69, 136, 1);
  static Color nngasuOrangeColor = const Color.fromRGBO(239, 103, 0, 1);

  static String crrUsername = "administrator";
  // static String token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbmlzdHJhdG9yIiwiZXhwIjoxNjUzNzcxNjAwfQ.yo1jZj_Y2oNgPBJ3e9um2az1dIoTwGvnUYF46SQvyFA2XD4AKeoBwolhQSTkeUwjP8wiz4NdKj3CwdbRCFveXg";
  static String token = "";
  // Color.fromRGBO(0, 69, 136, 1) - Синий цвет ННГАСУ
  // Color.fromRGBO(239, 103, 0, 1) - Оранжевый цвет ННГАСУ
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NNGASU',
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.black))
      ),
      // home: AuthPage(),
      home: token.isEmpty ? AuthPage() : HomePage(),
    );
  }

}