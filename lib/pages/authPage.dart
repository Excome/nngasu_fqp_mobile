import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget{
  AuthPage({Key? key}) : super(key: key);
  bool _isLogin = false;

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _logo(){
      return const Padding(
        padding: EdgeInsets.only(top: 150),
        child: Align(
          child: Text('NNGASU', style: TextStyle(fontSize: 65, fontWeight: FontWeight.bold, color: Colors.white),),
        ),
      );
    }

    Widget _input(String placeholder, Icon icon, TextEditingController controller, bool obscure){
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white30),
            hintText: placeholder,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 4)
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 4)
              ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: icon,
              ),
            )
          ),
        ),
      );
    }

    Widget _button(String text, void Function() func){
      return RaisedButton(
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
        ),
        onPressed: (){ func(); },
      );
    }

    Widget _form(String label, void Function() func) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: _input("Username", const Icon(Icons.email), _usernameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Password", const Icon(Icons.lock), _passwordController, true),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func)
            ),
          )
        ],
      );
    }


    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          _logo(),
          _form('ВОЙТИ', (){})
        ],
      ),
    );
  }
}