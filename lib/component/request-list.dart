import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/request.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/requestDetail.dart';
import 'package:nngasu_fqp_mobile/service/requestService.dart';

class RequestList extends StatefulWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  List<Request> requests = [];
  @override
  void initState()  {
    fetchRequests(context);
    super.initState();
  }

  void fetchRequests(context) async {
    var requestList = await RequestService.fetchRequests(0, Application.token);
    setState(() => requests.addAll(requestList));
  }

  @override
  Widget build(BuildContext context) {
    var requestList = Expanded(
        child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white30),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      alignment: Alignment.center,
                      width: 50,
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(requests[index].id.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              color: Application.nngasuBlueColor)),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 1,
                                color: Application.nngasuOrangeColor)),
                      ),
                    ),
                    title: Text("Ауд.: ${requests[index].audience}",
                        style: TextStyle(
                            fontSize: 18, color: Application.nngasuBlueColor)),
                    subtitle: Text(
                        // "Автор: ${requests[index].author.surName} ${requests[index].author.firstName}",
                        "Автор: ${requests[index].author.userName}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black)),
                    trailing: Container(
                      alignment: Alignment.centerRight,
                      width: 90,
                      child: Text(
                        requests[index].status ? "Выполнено" : "Не выполнено",
                        style: TextStyle(color: requests[index].status ? Colors.green : Colors.red),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RequestDetail(request: requests[index],)));
                    },
                  ),
                ),
              );
            }));

    return Column(
      children: <Widget>[requestList],
    );
  }
}
