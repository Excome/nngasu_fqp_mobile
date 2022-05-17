import 'package:flutter/material.dart';

import '../main.dart';

class CreateRequest extends StatelessWidget {
  const CreateRequest({Key? key}) : super(key: key);

  // String dropdownValue = "Test 1";

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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Номер аудитории',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: DropdownButton<String>(
                isExpanded: true,
                items: <String>['Test 1', 'Test 2', 'Test 3', 'Test 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: "Test 1",
                underline: Container(
                  height: 2,
                  color: Application.nngasuOrangeColor,
                ),
                onChanged: (Object? value) {},
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Описание',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
