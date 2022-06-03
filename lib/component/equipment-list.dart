import 'package:flutter/material.dart';
import 'package:nngasu_fqp_mobile/main.dart';
import 'package:nngasu_fqp_mobile/screen/editEquipment.dart';
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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    alignment: Alignment.center,
                    width: 50,
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(_equipments[index].id.toString(),
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
                  title: Text(_equipments[index].type, style: const TextStyle(color: Colors.grey, fontSize: 14),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Text(_equipments[index].name, style: const TextStyle(color: Application.nngasuBlueColor, fontSize: 18)),
                      Text("Кол-во: ${_equipments[index].count}", style: const TextStyle(color: Application.nngasuBlueColor, fontSize: 13)),
                      Text(_equipments[index].description),
                    ],
                  ),
                  trailing: IconButton(
                    alignment: Alignment.centerRight,
                    icon: const Icon(Icons.edit, color: Application.nngasuBlueColor),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditEquipment(equipment: _equipments[index],)));
                    },
                  ),
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
