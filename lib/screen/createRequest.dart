import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        await EquipmentService.fetchEquipments(page, Application.token, size: 100);
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
        isDense: true,
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

  void _createRequest() async {
    var audience = _audienceCntrl.text;
    var description = _descriptionCntrl.text;
    var author = User(Application.crrUsername, "");
    var equipment = _selectedEquipments.map((equipment) =>Equipment(equipment.replaceAll(RegExp(r'.*: '), ""), 0, "", "")).toList();
    var request = Request(author, audience, equipment, description: description);
    var response = await RequestService.createRequest(request, Application.token);
    if (response.audience.isNotEmpty) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Application.nngasuOrangeColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light
        ),
          title: const Text('ННГАСУ | ТРО | Создание заявки'),
          backgroundColor: Application.nngasuOrangeColor),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 50),
                child: DInput(
                  isRequired: true,
                  controller: _audienceCntrl,
                  hint: "Номер аудитории",
                  validator: (value) => !value!.contains('-') ? "Введите аудиторию в формате 2-102" : null,
                  inputType: const TextInputType.numberWithOptions(signed: true),
                )),
            _dropDownList(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DInput(
                  controller: _descriptionCntrl,
                  hint: "Описание",
                  inputType: TextInputType.text,
                )),
            _button("Создать заявку", _createRequest)
          ],
        ),
      ),
    );
  }
}
