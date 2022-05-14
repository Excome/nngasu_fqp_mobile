import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/request.dart';
import 'package:nngasu_fqp_mobile/domain/user.dart';
import 'package:nngasu_fqp_mobile/main.dart';

class RequestList extends StatefulWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final requests = <Request>[
    Request(1, User("test1_user_author", "test1@test.com", "test1FirstName", "test1Surname"),
        User("test2_user_responsible", "test2@test.com", "test2FirstName", "test2Surname"), [], "1-201", "Test1 description", true),
    Request(2, User("test3_user_author", "test3@test.com", "test3FirstName", "test3Surname"),
        User("test4_user_responsible", "test4@test.com", "test4FirstName", "test4Surname"), [], "2-105", "Test2 description", false),
    Request(333, User("test5_user_author", "test5@test.com", "test5FirstName", "test5Surname"),
        User("test6_user_responsible", "test6@test.com", "test6FirstName", "test6Surname"), [], "2-211", "Test3 description", false),
    Request(1578, User("test7_user_author", "test7@test.com", "Анатолий", "Супрун"),
        User("test8_user_responsible", "test8@test.com", "test8FirstName", "test8Surname"), [], "8-302", "Test4 description", true),
  ];

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
                      child: Text(requests[index].id.toString(), style: TextStyle(fontSize: 18, color: Application.nngasuBlueColor)),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1, color: Application.nngasuOrangeColor)),
                      ),
                    ),
                    title: Text("Ауд.: ${requests[index].audience}", style: TextStyle(fontSize: 18, color: Application.nngasuBlueColor)),
                    subtitle: Text("Автор: ${requests[index].author.surName} ${requests[index].author.firstName}", style: const TextStyle(fontSize: 16, color: Colors.black)),
                    trailing: Container(
                      width: 20,
                      color: requests[index].status ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              );
            })
    );


    return Column(
      children: <Widget>[
        requestList
      ],
    );
  }
}
