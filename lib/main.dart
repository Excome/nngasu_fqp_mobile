import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nngasu_fqp_mobile/page/auth.dart';

void main() =>  runApp(const Application());

class Application extends StatelessWidget{
  const Application({Key? key}) : super(key: key);
  static const String serverUrl = 'http://192.168.0.198:8080';
  // static const String serverUrl = 'http://195.122.251.100:8080';
  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NNGASU',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(50, 65, 85, 1),
        textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.white))
      ),
      home: AuthPage(),
    );
  }

}