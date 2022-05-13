import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/service/authService.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surNameController = TextEditingController();
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return const Padding(
        padding: EdgeInsets.only(top: 150),
        child: Align(
          child: Text(
            'NNGASU',
            style: TextStyle(
                fontSize: 65, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      );
    }

    Widget _version() {
      return const Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: EdgeInsets.only(top: 250, right: 10),
            child: Text('v0.1alfa',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
      );
    }

    Widget _input(String placeholder, Icon icon,
        TextEditingController controller, bool obscure) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
              hintStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white30),
              hintText: placeholder,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 4)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54, width: 4)),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: icon,
                ),
              )),
        ),
      );
    }

    Widget _button(String text, void Function() func) {
      return RaisedButton(
        splashColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Text(text,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor)),
        onPressed: () {
          func();
        },
      );
    }

    Widget _loginForm(String label, void Function() func) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: _input("Имя пользователя", const Icon(Icons.email),
                _usernameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input(
                "Пароль", const Icon(Icons.lock), _passwordController, true),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func)),
          )
        ],
      );
    }

    Widget _registrationForm(String label, void Function() func) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: _input("Имя пользователя", const Icon(Icons.person),
                _usernameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input(
                "Email", const Icon(Icons.email), _emailController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input(
                "Имя", const Icon(Icons.person), _firstNameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input(
                "Фамилия", const Icon(Icons.person), _surNameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input(
                "Пароль", const Icon(Icons.lock), _passwordController, true),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Подтверждение пароля", const Icon(Icons.lock),
                _passwordConfController, true),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func)),
          )
        ],
      );
    }

    void _loginUser() async {
      var token = await AuthService.login(_usernameController.text, _passwordController.text);
      if (token == "failure") {
        _passwordController.clear();
      }
    }

    void _registerUser() async {
      var user = User.forRegister(
          _usernameController.text,
          _emailController.text,
          _firstNameController.text,
          _surNameController.text,
          _passwordController.text,
          _passwordConfController.text);
      var newUser = await AuthService.register(user);
      Application.logger.d(newUser);
    }

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _logo(),
            (_showLogin
                ? Column(
                    children: <Widget>[
                      _loginForm('ВОЙТИ', _loginUser),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          child: const Text('Нет аккаунта? Зарегистрироваться!',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          onTap: () {
                            setState(() {
                              _showLogin = false;
                            });
                          },
                        ),
                      )
                    ],
                  )
                : Column(
                    children: <Widget>[
                      _registrationForm('ЗАРЕГИСТРИРОВАТЬСЯ', _registerUser),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: GestureDetector(
                          child: const Text('Уже есть аакаунт? Войти!',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          onTap: () {
                            setState(() {
                              _showLogin = true;
                            });
                          },
                        ),
                      )
                    ],
                  )),
            _version()
          ],
        )));
  }
}
