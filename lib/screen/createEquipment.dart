import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nngasu_fqp_mobile/domain/equipment.dart';
import 'package:nngasu_fqp_mobile/service/equipmentService.dart';

import '../main.dart';
import 'home.dart';

class CreateEquipment extends StatefulWidget {
  const CreateEquipment({Key? key}) : super(key: key);

  @override
  State<CreateEquipment> createState() => _CreateEquipmentState();
}

class _CreateEquipmentState extends State<CreateEquipment> {
  final TextEditingController _nameCntrl = TextEditingController();
  final TextEditingController _typeCntrl = TextEditingController();
  final TextEditingController _countCntrl = TextEditingController();
  final TextEditingController _decriptionCntrl = TextEditingController();
  bool _errorFlag = false;

  Widget _button(String text, void Function() func) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: RaisedButton(
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Application.nngasuOrangeColor,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light),
            title: const Text('Создание оборудования'),
            backgroundColor: Application.nngasuOrangeColor),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: DInput(
                        onChanged: (value) {
                          _errorFlag = false;
                        },
                        controller: _nameCntrl,
                        isRequired: true,
                        title: "Наименование",
                        validator: (value) => _errorFlag
                            ? "Данное наименование уже используется"
                            : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: DInput(
                        controller: _typeCntrl,
                        isRequired: true,
                        title: "Тип",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: DInput(
                        controller: _countCntrl,
                        isRequired: true,
                        title: "Количество",
                        inputType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: DInput(
                        controller: _decriptionCntrl,
                        isRequired: false,
                        title: "Описание",
                        maxLine: 5,
                      ),
                    ),
                    _button("Создать оборудование", _createRequest)
                  ],
                ))));
  }

  void _createRequest() async {
    var name = _nameCntrl.text.trim();
    var type = _typeCntrl.text.trim();
    var count = int.parse(_countCntrl.text.trim());
    var description = _decriptionCntrl.text.trim();
    var equipment = Equipment(name, count, type, description);

    var response = await EquipmentService.createEquipment(equipment, Application.token);
    if (response.id == 0 && response.name == "") {
      setState(() => _errorFlag = true);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(pageIndex: 1,)), (route) => false);
    }
  }
}
