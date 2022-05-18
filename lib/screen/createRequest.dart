import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/equipment.dart';
import 'package:nngasu_fqp_mobile/domain/request.dart';
import 'package:nngasu_fqp_mobile/service/equipmentService.dart';
import 'package:multiselect/multiselect.dart';
import 'package:nngasu_fqp_mobile/service/requestService.dart';

import '../domain/user.dart';
import '../main.dart';

class CreateRequest extends StatefulWidget {
  const CreateRequest({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  final TextEditingController _audienceCntrl = TextEditingController();
  final TextEditingController _descriptionCntrl = TextEditingController();
  List<Equipment> _equipments = [];
  List<String> _selectedEquipments = [];

  @override
  void initState() {
    fetchEquipments(0);
    super.initState();
  }

  void fetchEquipments(int page) async {
    var equipments =
        await EquipmentService.fetchEquipments(page, Application.token);
    setState(() => _equipments.addAll(equipments));
  }

  List<String> stringEquipments(List<Equipment> equipments) {
    return equipments
        .map((equipment) => "${equipment.type}: ${equipment.name}")
        .toList();
  }

  Widget _dropDownList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: DropDownMultiSelect(
        onChanged: (List<String> x) {
          setState(() {
            _selectedEquipments = x;
          });
        },
        options: stringEquipments(_equipments),
        selectedValues: _selectedEquipments,
        whenEmpty: 'Выберите оборудование',
      ),
    );
  }

  Widget _input(String placeholder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: placeholder,
        ),
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

  void _createRequest() async {
    var audience = _audienceCntrl.text;
    var description = _descriptionCntrl.text;
    var author = User(Application.crrUsername, "");
    var equipment = _selectedEquipments.map((equipment) =>Equipment(equipment.replaceAll(RegExp(r'.*: '), ""), 0, "", "")).toList();
    var request = Request(author, audience, equipment, description: description);
    var response = await RequestService.createRequest(request, Application.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('ННГАСУ | ТРО | Создание заявки'),
          backgroundColor: Application.nngasuOrangeColor),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _input('Номер аудитории', _audienceCntrl),
            _dropDownList(),
            _input('Описание', _descriptionCntrl),
            _button("Создать заявку", _createRequest)
          ],
        ),
      ),
    );
  }
}
