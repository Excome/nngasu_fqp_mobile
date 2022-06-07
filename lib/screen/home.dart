import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nngasu_fqp_mobile/component/request-list.dart';
import 'package:nngasu_fqp_mobile/component/user-list.dart';
import 'package:nngasu_fqp_mobile/domain/role.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/createRequest.dart';
import 'package:nngasu_fqp_mobile/screen/userProfile.dart';

import '../component/equipment-list.dart';
import 'createEquipment.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.pageIndex}) : super(key: key);
  int? pageIndex;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> _widgetOptions = <Widget>[
    RequestList(),
    EquipmentList(),
    UserList(),
    UserProfile()
  ];
  int sectionIndex = 0;


  @override
  void initState() {
    if (widget.pageIndex != null) {
      sectionIndex = widget.pageIndex!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
            Visibility(
                visible: sectionIndex == 3,
                child: IconButton(
                  padding: const EdgeInsets.only(right: 10),
                  onPressed: () => {},
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: "Настройки",
                )
            )
          ],
      ),
      body: _widgetOptions.elementAt(sectionIndex),
      floatingActionButton: _floatingActionButton(context),
      bottomNavigationBar: navigationBar(sectionIndex),
    );
  }

  Visibility _floatingActionButton(BuildContext context) {
    return Visibility(
        visible: (sectionIndex == 0 && Application.crrUser.hasPriorityMoreThen(Role.ROLE_TEACHER)) || (sectionIndex == 1 && Application.crrUser.hasPriorityMoreThen(Role.ROLE_MODERATOR)),
        child: FloatingActionButton(
          onPressed: () => {
            if (sectionIndex == 0) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const CreateRequest()))
            } else if (sectionIndex == 1) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const CreateEquipment()))
            }
          },
          tooltip: sectionIndex == 0 ? "Создать заявку" : "Создать оборудование",
          child: const Icon(Icons.add),
          elevation: 4.0,
          backgroundColor: Application.nngasuOrangeColor,
        )
    );
  }

  Widget navigationBar(int sectionIndex) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Заявки',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.keyboard_rounded),
          label: 'Оборудование',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle_sharp),
          label: 'Пользователи',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'Профиль',
        ),
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
