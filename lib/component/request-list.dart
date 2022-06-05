import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/domain/request.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/requestDetail.dart';
import 'package:nngasu_fqp_mobile/service/requestService.dart';

class RequestList extends StatefulWidget {
  const RequestList({Key? key, this.userName }) : super(key: key);
  final String? userName;
  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final ScrollController _scrollController = ScrollController();
  final List<Request> _requests = [];
  int _page = 0;
  bool _isLoading = true;

  @override
  void initState()  {
    fetchRequests(_page);
    _scrollController.addListener(pagination);
    super.initState();
  }

  void fetchRequests(int page) async {
    var requestList = <Request> [];
    if (widget.userName == null) {
      requestList = await RequestService.fetchRequests(page, Application.token);
    }
    else {
      requestList = await RequestService.fetchUserRequests(page, widget.userName, Application.token);
    }
    if (requestList.isNotEmpty) {
      _page += 1;
      setState(() => _requests.addAll(requestList));
    } else {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var requestList = Expanded(
        child: ListView.builder(
          controller: _scrollController,
            itemCount: _requests.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(color: !_requests[index].status ? Color.fromRGBO(235, 235, 235, 0.7) : Colors.white30),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      alignment: Alignment.center,
                      width: 50,
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(_requests[index].id.toString(),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Application.nngasuBlueColor)),
                      decoration: const BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                width: 1,
                                color: Application.nngasuOrangeColor)),
                      ),
                    ),
                    title: Text(_requests[index].audience,
                        style: const TextStyle(
                            fontSize: 18, color: Application.nngasuBlueColor)),
                    subtitle: Text(
                        "${_requests[index].author.surName} ${_requests[index].author.firstName}",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black)),
                    trailing: Container(
                      alignment: Alignment.centerRight,
                      width: 90,
                      child: Text(
                        _requests[index].status ? "Выполнено" : "Не выполнено",
                        style: TextStyle(color: _requests[index].status ? Colors.green : Colors.red),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RequestDetail(request: _requests[index])));
                    },
                  ),
                ),
              );
            }));

    return Column(
      children: <Widget>[requestList],
    );
  }

  void pagination() {
    if (_scrollController.position.extentAfter <= 0 && _isLoading) {
      fetchRequests(_page);
    }
  }
}
