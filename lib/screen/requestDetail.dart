import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/request.dart';
import 'package:nngasu_fqp_mobile/screen/home.dart';
import 'package:nngasu_fqp_mobile/service/requestService.dart';

import '../domain/user.dart';
import '../main.dart';

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

  @override
  void initState() {
    fetchRequest(context, widget.request.id);
    super.initState();
  }

  Widget _textField(String text, String label, TextEditingController controller){
    controller.text = text;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child:  TextField(
        enabled: false,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _rowTextField(String text, String label, TextEditingController controller, {double? width, Color color = Colors.white}){
    controller.text = text;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          width: width,
          child: TextField(
            enabled: false,
            controller: controller,
            decoration: InputDecoration(
              fillColor: color,
              filled: true,
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('ННГАСУ | ТРО'),
            backgroundColor: Application.nngasuOrangeColor),
        body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  _rowTextField(request.id.toString(), "Номер", _idCntrl, width: 100),
                  _rowTextField(request.status ? 'Выполнено' : 'Не выполнено', "Статус", _statusCntrl, width: 251, color: request.status ? Colors.green : Colors.red)
                ],),
                _textField(request.audience, "Аудитория", _audienceCntrl),
                _textField("${request.author.surName} ${request.author.firstName}", "Автор", _authorCntrl),
                _textField("${request.responsible.surName} ${request.responsible.firstName}", "Ответственный", _responsibleCntrl),
                _textField("${request.equipment.map((value) => '${value.name}').toString()}", "Оборудование", _equipmentCntrl),
                _textField(request.description, "Описание", _descriptionCntrl)
              ],
            )
        ));
  }

  fetchRequest(BuildContext context, int id) async {
    var request = await RequestService.fetchRequest(id, Application.token);
    setState(() => this.request = request);
  }
}
