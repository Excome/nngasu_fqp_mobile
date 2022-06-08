import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:nngasu_fqp_mobile/screen/authentication.dart';
import 'package:localstore/localstore.dart';
import 'package:nngasu_fqp_mobile/screen/home.dart';

import 'domain/role.dart';
import 'domain/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Application());
}

class Application extends StatelessWidget{
  const Application({Key? key}) : super(key: key);
  static final Logger logger = Logger();
  static final db = Localstore.instance;
  static const dbAuthId = "nngasu_tro_auth_db_document";
  static const dbCrrUserId = "nngasu_current_user_db_document";
  static const Color nngasuBlueColor = Color.fromRGBO(0, 69, 136, 1);
  static const Color nngasuOrangeColor = Color.fromRGBO(239, 103, 0, 1);

  static String serverUrl = 'http://192.168.0.198:8080';
  // static String serverUrl = 'http://195.122.251.100:8080';

  static String crrUsername = "";
  static String token = "";
  static User crrUser = User("", "");
  static bool isAdmin = false;
  @override
  Widget build(BuildContext context) {
    getServerUrlFromDb();
    return MaterialApp(
      title: 'NNGASU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.black))
      ),
      // home: AuthPage(),
      home: token.isNotEmpty && crrUsername.isNotEmpty ? HomePage() : AuthPage(),
      // home: const HomePage(),
    );
  }

  void getServerUrlFromDb() async {
    var authMap = await Application.db.collection("auth").doc(dbAuthId).get();
    if (authMap != null && authMap != {}){
      var srvUrl = authMap["serverUrl"];
      if (srvUrl != null){
        Application.serverUrl = srvUrl;
      }
    }
  }
}