import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/component/confirmDialog.dart';
import 'package:nngasu_fqp_mobile/domain/equipment.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/home.dart';
import 'package:nngasu_fqp_mobile/service/equipmentService.dart';

class EditEquipment extends StatefulWidget {
  EditEquipment({Key? key, required this.equipment}) : super(key: key);
  Equipment equipment;

  @override
  State<EditEquipment> createState() => _EditEquipmentState();
}

class _EditEquipmentState extends State<EditEquipment> {
  final TextEditingController _nameCntrl = TextEditingController();
  final TextEditingController _typeCntrl = TextEditingController();
  final TextEditingController _countCntrl = TextEditingController();
  final TextEditingController _descriptionCntrl = TextEditingController();
  Equipment _equipment = Equipment("", 0, "", "");

  @override
  void initState() {
    fetchEquipment(widget.equipment.name);
  }

  Widget _menuButton(String text, Color textColor, void Function() func) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(160, 50),
            elevation: 0,
            primary: Colors.white),
        onPressed: func,
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('ННГАСУ | ТРО'),
          backgroundColor: Application.nngasuOrangeColor),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DInput(
                      controller: _nameCntrl,
                      label: "Наименование",
                      isRequired: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DInput(
                      controller: _typeCntrl,
                      label: "Тип",
                      isRequired: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DInput(
                      controller: _countCntrl,
                      label: "Количество",
                      isRequired: true,
                      inputType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DInput(
                      controller: _descriptionCntrl,
                      label: "Описание",
                      isRequired: false,
                      maxLine: 8,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: _menuButton("Удалить", Colors.red, () {
                            showDialog(context: context, builder: (context) {
                              return ConfirmDialog(
                                  title: "Удалить",
                                  description: "Вы уверены что хотите удалить данное оборудование?",
                                  leftButtonText: "Отмена",
                                  lbOnPressed: () { Navigator.of(context).pop(); },
                                  rightButtonText: "Удалить",
                                  rbOnPressed: deleteEquipment
                              );
                            });
                          })),
                      Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: _menuButton("Изменить", Application.nngasuBlueColor, editEquipment)),
                    ],
                  ),
                ],
          ),
        )));
  }

  void fetchEquipment(String name) async {
    var response = await EquipmentService.fetchEquipment(name, Application.token);
    if (response.name != "") {
      setState(() {
        _equipment = response;
        _nameCntrl.text = _equipment.name;
        _typeCntrl.text = _equipment.type;
        _countCntrl.text = _equipment.count.toString();
        _descriptionCntrl.text = _equipment.description;
      });
    }
  }

  void editEquipment() async {
    var name = _nameCntrl.text.trim();
    var type = _typeCntrl.text.trim();
    var count = int.parse(_countCntrl.text.trim());
    var description = _descriptionCntrl.text;
    var newEquipment = Equipment(name, count, type, description);
    if (_equipment == newEquipment) {
      return;
    }
    var response = await EquipmentService.editEquipment(newEquipment, Application.token);
    if (response.name != "") {
      Navigator.of(context).pop();
    }
  }

  void deleteEquipment() async {
    var result = await EquipmentService.deleteEquipment(_equipment, Application.token);
    if (result) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(pageIndex: 1,)));
    }
  }
}
