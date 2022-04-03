import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/pages/authPage.dart';

void main() =>  runApp(const Application());

class Application extends StatelessWidget{
  const Application({Key? key}) : super(key: key);

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