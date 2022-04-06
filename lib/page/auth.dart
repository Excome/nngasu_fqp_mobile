import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget{
  AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surNameController = TextEditingController();

  String _username = "";
  String _email = "";
  String _password = "";
  String _passwordConf = "";
  String _firstName = "";
  String _surName = "";
  bool _showLogin = true;

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

    Widget _loginForm(String label, void Function() func) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: _input("Имя пользователя", const Icon(Icons.email), _usernameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Пароль", const Icon(Icons.lock), _passwordController, true),
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

    Widget _registrationForm(String label, void Function() func) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: _input("Имя пользователя", const Icon(Icons.person), _usernameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Email", const Icon(Icons.email), _emailController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Имя", const Icon(Icons.person), _firstNameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Фамилия", const Icon(Icons.person), _surNameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Пароль", const Icon(Icons.lock), _passwordController, true),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Подтверждение пароля", const Icon(Icons.lock), _passwordConfController, true),
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

/*    Widget _bottomWave(){
      return Expanded(
          child: Align(
            child: ClipPath(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
              ),
              clipper: BottomWaveClipper(),
            ),
            alignment: Alignment.bottomCenter,
          )
      );
    }*/

    void _loginUser(){
      _username = _usernameController.text;
      _password = _passwordController.text;

      _usernameController.clear();
      _passwordController.clear();
    }

    void _registerUser(){
      _username = _usernameController.text;
      _email = _emailController.text;
      _firstName = _firstNameController.text;
      _surName = _surNameController.text;
      _password = _passwordController.text;
      _passwordConf = _passwordConfController.text;


    }
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _logo(),
                (
                    _showLogin
                        ? Column(
                      children: <Widget>[
                        _loginForm('ВОЙТИ', _loginUser),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            child: const Text('Нет аккаунта? Зарегистрироваться!', style: TextStyle(fontSize: 20, color: Colors.white)),
                            onTap: (){
                              setState(() {
                                _showLogin = false;
                              });
                            },
                          ),
                        )
                      ],
                    ) : Column(
                      children: <Widget>[
                        _registrationForm('ЗАРЕГИСТРИРОВАТЬСЯ', _registerUser),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 40),
                          child: GestureDetector(
                            child: const Text('Уже есть аакаунт? Войти!', style: TextStyle(fontSize: 20, color: Colors.white)),
                            onTap: (){
                              setState(() {
                                _showLogin = true;
                              });
                            },
                          ),
                        )
                      ],
                    )
                ),
              ],
            )
        )
    );
  }
}
/*
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}*/
