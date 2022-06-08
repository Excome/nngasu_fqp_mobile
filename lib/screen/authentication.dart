import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nngasu_fqp_mobile/domain/role.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/home.dart';
import 'package:nngasu_fqp_mobile/screen/settings.dart';
import 'package:nngasu_fqp_mobile/service/authService.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

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
  final TextEditingController _serverApiController =
      TextEditingController(text: Application.serverUrl);
  bool _showLogin = true;
  bool _isError = false;

  @override
  void initState() {
    _checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    Widget _logo() {
      return const Padding(
        padding: EdgeInsets.only(top: 150),
        child: Align(
          child: Text(
            'ННГАСУ | ТРО',
            style: TextStyle(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 69, 136, 1)),
          ),
        ),
      );
    }

    Widget _version() {
      return const Align(
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.only(top: 50, right: 10),
            child: Text('version 0.1alfa',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
      );
    }

    Widget _serverApi() {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
        child: TextField(
            controller: _serverApiController,
            onChanged: (value) =>
                {Application.serverUrl = _serverApiController.text},
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Описание',
            )),
      );
    }

    Widget _input(String placeholder, Icon icon,
        TextEditingController controller, bool obscure) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
              hintStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38),
              hintText: placeholder,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(0, 69, 136, 0.8), width: 4)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromRGBO(0, 69, 136, 0.5), width: 4)),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: IconTheme(
                  data: const IconThemeData(
                      color: Color.fromRGBO(239, 103, 0, 1)),
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
        color: const Color.fromRGBO(239, 103, 0, 1),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: _input("Имя пользователя", const Icon(Icons.person),
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
          ),
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
            child: _input("Имя", const Icon(Icons.arrow_drop_up_sharp),
                _firstNameController, false),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _input("Фамилия", const Icon(Icons.arrow_drop_up_sharp),
                _surNameController, false),
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
      var authStore = await Application.db
          .collection('auth')
          .doc(Application.dbAuthId)
          .get();
      var _username = _usernameController.text.trim();
      var _password = _passwordController.text.trim();
      var token = await AuthService.login(_username, _password);
      if (token != 'failure') {
        authStore = authStore ?? {};
        authStore['token'] = token;
        authStore['userName'] = _username;
        Application.db
            .collection("auth")
            .doc(Application.dbAuthId)
            .set(authStore);
        Application.token = token;
        Application.crrUsername = _username;
        var crrUser = await UserService.fetchUser(Application.crrUsername, Application.token);
        Application.crrUser = crrUser;
        Application.db.collection("crrUser").doc(Application.dbCrrUserId).set(crrUser.toJson());
        crrUser.roles.contains(Role.ROLE_ADMIN) ? Application.isAdmin = true : Application.isAdmin = false;
        setState(() {});
      } else {
        _passwordController.clear();
        setState(() => _isError = true);
      }
    }

    void _registerUser() async {
      var user = User(_usernameController.text, _emailController.text,
          firstName: _firstNameController.text,
          surName: _surNameController.text,
          pass: _passwordController.text,
          passConfirm: _passwordConfController.text);
      var newUser = await AuthService.register(user);
      if (user.id != 0 && user.pass == ""){
        setState(() {
          _isError = false;
          _showLogin = true;
        });
      } else {
        _isError = true;
      }
      Application.logger.d(newUser);
    }

    return Application.token.isNotEmpty
        ? HomePage()
        : Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Application.nngasuOrangeColor,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
              title: const Text('ННГАСУ | ТРО'),
              // leading: const Icon(Icons.home_rounded),
              backgroundColor: Application.nngasuOrangeColor,
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage())),
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: "Настройки",
                )
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            body: Application.token.isNotEmpty
                ? HomePage()
                : SingleChildScrollView(
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
                                    child: const Text(
                                        'Нет аккаунта? Зарегистрироваться!',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                    onTap: () {
                                      setState(() {
                                        _showLogin = false;
                                        _isError = false;
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                _registrationForm(
                                    'ЗАРЕГИСТРИРОВАТЬСЯ', _registerUser),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 40),
                                  child: GestureDetector(
                                    child: const Text(
                                        'Уже есть аккаунт? Войти!',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                    onTap: () {
                                      setState(() {
                                        _showLogin = true;
                                        _isError = false;
                                      });
                                    },
                                  ),
                                )
                              ],
                            )),
                      _errorMesage(),
                      // _serverApi(),
                      _version()
                    ],
                  )));
  }

  Visibility _errorMesage() {
    return Visibility(
        visible: _isError,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            _showLogin
                ? "Не правильный логин или пароль"
                : "Имя пользователя или email уже занято",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ));
  }

  void _checkAuth() async {
    var authMap = await Application.db.collection('auth').doc(Application.dbAuthId).get();
    var crrUserMap = await Application.db.collection('crrUser').doc(Application.dbCrrUserId).get();
    if (authMap != null &&
        authMap['token'] != "" &&
        authMap['userName'] != "" &&
        (crrUserMap != null || crrUserMap != {})) {
      setState(() {
        Application.token = authMap['token'];
        Application.crrUsername = authMap['userName'];
        Application.crrUser = User.fromJson(crrUserMap!);
      });
    }
  }
}
