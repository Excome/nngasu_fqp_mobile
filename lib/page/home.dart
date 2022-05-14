import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final User user = Provider.
    // throw UnimplementedError();
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            title: const Text('ННГАСУ | ТРО'),
            leading: const Icon(Icons.home_rounded),
        backgroundColor: Application.nngasuOrangeColor),
        body: Container(

        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Заявки',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            )
          ],
          currentIndex: sectionIndex,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Application.nngasuBlueColor,
          onTap: (int index) {
            setState(() => sectionIndex = index);
          },
        ),
      ),
    );
  }
}
