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
  int sectionIndex = 0;
  Request request = Request(User("",""), "", []);

  @override
  void initState() {
    fetchRequest(context, widget.request.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('ННГАСУ | ТРО'),
          backgroundColor: Application.nngasuOrangeColor),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Text("Автор: ${request.author.firstName} '${request.author.userName}' ${request.author.surName}\nСтатус: ${request.status}"),
      ),
    );
  }

  fetchRequest(BuildContext context, int id) async {
    var request = await RequestService.fetchRequest(id, Application.token);
    setState(() => this.request = request);
  }
}
