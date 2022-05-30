import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/service/equipmentService.dart';

import '../domain/equipment.dart';

class EquipmentList extends StatefulWidget {
  const EquipmentList({Key? key}) : super(key: key);

  @override
  State<EquipmentList> createState() => _EquipmentListState();
}

class _EquipmentListState extends State<EquipmentList> {
  final ScrollController _scrollController = ScrollController();
  final List<Equipment> _equipments = [];
  int _page = 0;
  bool _isLoading = true;

  @override
  void initState() {
    fetchEquipments(_page);
    _scrollController.addListener(pagination);
  }

  @override
  Widget build(BuildContext context) {
    var requestListBuilder = Expanded(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: _equipments.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  child: Text("${_equipments[index].name}"),
                ),
              );
            }
        )
    );
    return Column(
      children: <Widget> [requestListBuilder],
    );
  }

  void fetchEquipments(int page) async {
    var equipments = await EquipmentService.fetchEquipments(page, Application.token);
    if (equipments.isNotEmpty){
      _page += 1;
      setState(() => _equipments.addAll(equipments));
    } else {
      _isLoading = false;
    }
  }

  void pagination() {
    if (_scrollController.position.extentAfter <= 0 && _isLoading) {
      fetchEquipments(_page);
    }
  }
}
