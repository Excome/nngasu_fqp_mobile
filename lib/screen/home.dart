import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/component/request-list.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/createRequest.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> _widgetOptions = <Widget>[
    RequestList(),
    Scaffold(),
    Scaffold()
  ];
  int sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          title: const Text('ННГАСУ | ТРО'),
          leading: const Icon(Icons.home_rounded),
          backgroundColor: Application.nngasuOrangeColor),
      body: _widgetOptions.elementAt(sectionIndex),
      floatingActionButton: Visibility(
        visible: sectionIndex == 0,
          child: FloatingActionButton(
            onPressed: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateRequest()))},
            tooltip: "Создать заявку",
            child: const Icon(Icons.add),
            elevation: 4.0,
            backgroundColor: Application.nngasuOrangeColor,
          )
      ),
      bottomNavigationBar: navigationBar(sectionIndex),
    );
  }

  Widget navigationBar(int sectionIndex) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Заявки',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.keyboard_rounded),
          label: 'Оборудование',
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
        setState(() => this.sectionIndex = index);
      },
    );
  }
}
