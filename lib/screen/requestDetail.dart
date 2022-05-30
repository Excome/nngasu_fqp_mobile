import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:nngasu_fqp_mobile/domain/request.dart';
import 'package:nngasu_fqp_mobile/screen/home.dart';
import 'package:nngasu_fqp_mobile/service/requestService.dart';
import 'package:nngasu_fqp_mobile/service/userService.dart';

import '../domain/equipment.dart';
import '../domain/user.dart';
import '../main.dart';
import '../service/equipmentService.dart';

class RequestDetail extends StatefulWidget {
  RequestDetail({Key? key, required this.request}) : super(key: key);
  Request request;
  @override
  State<RequestDetail> createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  final TextEditingController _idCntrl = TextEditingController();
  final TextEditingController _authorCntrl = TextEditingController();
  final TextEditingController _responsibleCntrl = TextEditingController();
  final TextEditingController _audienceCntrl = TextEditingController();
  final TextEditingController _descriptionCntrl = TextEditingController();
  final TextEditingController _equipmentCntrl = TextEditingController();
  final TextEditingController _statusCntrl = TextEditingController();
  int sectionIndex = 0;
  Request request = Request(User("",""), "", []);
  bool isEditMode = false;
  List<User> responsibleUsers = [User("","")];
  List<Equipment> equipments = [];
  List<String> _selectedEquipments = [];


  @override
  void initState() {
    fetchRequest(context, widget.request.id);
    fetchResponsibleUsers();
    fetchEquipment();
    super.initState();
  }

  Widget _textField(String text, String label, TextEditingController controller, {int? minLines}){
    controller.text = text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child:  TextField(
        minLines: minLines ?? 1,
        maxLines: 2,
        enabled: false,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _rowTextField(String text, String label, TextEditingController controller, {double? width, Color color = Colors.black}){
    controller.text = text;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          width: width,
          child: TextField(
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            enabled: false,
            controller: controller,
            decoration: InputDecoration(
              // fillColor: color,
              // filled: true,
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        )
    );
  }

  Widget _menuButton(String text, void Function() func, Color textColor) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(160, 50),
            elevation: 0,
            primary: Colors.white),
        onPressed: func,
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)));
  }

  Widget _responsibleDropdownList() {
    var items = responsibleUsers.map((User user) {
      return DropdownMenuItem(
          value: user, child: Text("${user.surName} ${user.firstName}"));
    }).toList();
    return DropdownButton(
        isExpanded: true,
        hint: Text("Ответственный"),
        icon: const Icon(Icons.person),
        value: request.responsible,
        items: items,
        onChanged: (user) {
          setState(() {
            request.responsible = user as User;
          });
        });
  }

  List<String> stringEquipments(List<Equipment> equipments) {
    return equipments
        .map((equipment) => "${equipment.type}: ${equipment.name}")
        .toList();
  }

  Widget _equipmentsDropdownList() {
     return DropDownMultiSelect(
        onChanged: (List<String> x) {
          setState(() {
            _selectedEquipments = x;
            request.equipment = _selectedEquipments.map((equipment) => Equipment(equipment.replaceAll(RegExp(r'.*: '), ""), 0, "", "")).toList();
          });
        },
        options: stringEquipments(equipments),
        selectedValues: _selectedEquipments,
        whenEmpty: 'Выберите оборудование',
      );
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: !isEditMode ? _viewColumn() : _editColumn()
            )));
  }

  Column _viewColumn() {
    return Column(
            children: <Widget>[
              Row(children: <Widget>[
                _rowTextField(request.id.toString(), "Номер", _idCntrl, width: 100),
                _rowTextField(request.status ? 'Выполнено' : 'Не выполнено', "Статус", _statusCntrl, width: 230, color: request.status ? Colors.green : Colors.red)
              ],),
              _textField(request.audience, "Аудитория", _audienceCntrl),
              _textField("${request.author.surName} ${request.author.firstName}", "Автор", _authorCntrl),
              _textField("${request.responsible.surName} ${request.responsible.firstName}", "Ответственный", _responsibleCntrl),
              _textField(request.equipment.map((value) => value.name).toString(), "Оборудование", _equipmentCntrl, minLines: 2),
              _textField(request.description, "Описание", _descriptionCntrl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Visibility(visible: !request.status, child: _menuButton("Закрыть заявку", completeRequest, Colors.green))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Visibility(visible: !isEditMode, child: _menuButton("Изменить заявку", () { setState(() { isEditMode = true; }); }, Application.nngasuBlueColor))),
                ],
              ),
            ],
          );
  }

  Column _editColumn() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _rowTextField(request.id.toString(), "Номер", _idCntrl, width: 100),
            _rowTextField(request.status ? 'Выполнено' : 'Не выполнено', "Статус", _statusCntrl, width: 230, color: request.status ? Colors.green : Colors.red)
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: DInput(
            controller: _audienceCntrl,
            title: "Аудитория",
            inputType: const TextInputType.numberWithOptions(signed: true),
            validator: (value) => !value!.contains('-') ? "Введите аудиторию в формате 2-102" : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: DInput(
            controller: _authorCntrl,
            title: "Автор",
            enabled: false,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: _responsibleDropdownList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: _equipmentsDropdownList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: DInput(
            controller: _descriptionCntrl,
            title: "Описание",
            minLine: 1,
            maxLine: 5,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: isEditMode,
                    child: _menuButton("Отмена", () {
                      setState(() {
                        isEditMode = false;
                        // isError = false;
                      });
                    }, Colors.red))),
            Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Visibility(
                    visible: isEditMode,
                    child: _menuButton("Изменить", editRequest,
                        Application.nngasuBlueColor))),
          ],
        ),
      ],
    );
  }

  fetchRequest(BuildContext context, int id) async {
    var request = await RequestService.fetchRequest(id, Application.token);
    setState(() => this.request = request);
  }

  fetchResponsibleUsers() async {
    var users = await UserService.fetchResponsibleUsers(Application.token);
    setState(() => responsibleUsers.addAll(users));
  }

  fetchEquipment() async {
    var equipments = await EquipmentService.fetchEquipments(0, Application.token, size: 100);
    setState(() {this.equipments.addAll(equipments); _selectedEquipments = stringEquipments(request.equipment);});
  }

  completeRequest() async {
    var request = await RequestService.editRequestStatus(this.request.id, true, Application.token);
    setState(() => this.request = request);
  }

  editRequest() async {
    request.audience = _audienceCntrl.text.trim();
    request.description = _descriptionCntrl.text;
    var response = await RequestService.editRequest(request, Application.token);
    if (response.id != 0) {
      request = response;
      setState(() => isEditMode = false);
    }
  }
}
