import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'container-template.dart';
import 'draw-area.dart';
import 'text-area.dart';

class CanvasPage extends StatelessWidget {
  final String roomCode = "HELLOW";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ContainerWidget(Column(
      mainAxisSize: MainAxisSize.max,
      children: [RoomCode(roomCode), DrawArea(), TextArea()],
    )));
  }
}

class RoomCode extends StatelessWidget {
  final String code;

  RoomCode(this.code);

  unFocusTextField (BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  copyCode(BuildContext context) {
    unFocusTextField(context);
    Clipboard.setData(ClipboardData(text: code))
        .then((value) => Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blueAccent,
              elevation: 10.0,
              content: Text(
                "Room code copied",
                style: TextStyle(color: Colors.white),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
      height: 40.0,
      decoration: BoxDecoration(
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Material(
              type: MaterialType.transparency,
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Room code : " + code,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )))),
          Container(
              margin: EdgeInsets.only(top: 9, bottom: 9),
              child: ElevatedButton(
                  onPressed: () => copyCode(context),
                  child: Text("copy",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(10))))
        ],
      ),
    );
  }
}
