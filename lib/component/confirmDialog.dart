import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {Key? key,
      required this.title,
      required this.description,
      required this.leftButtonText,
      required this.lbOnPressed,
      required this.rightButtonText,
      required this.rbOnPressed})
      : super(key: key);
  final String title;
  final String description;
  final String leftButtonText;
  final Function() lbOnPressed;
  final String rightButtonText;
  final Function() rbOnPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: SizedBox(
        height: 175,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(title,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 18)))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(description,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 16)))),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 90),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.white),
                          onPressed: lbOnPressed,
                          child: Text(leftButtonText,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black54))),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.white),
                          onPressed: rbOnPressed,
                          child: Text(rightButtonText,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.red)))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
