import 'package:flutter/material.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({Key key}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        child: Container(
          margin: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 20.0, top: 30.0),
          decoration: BoxDecoration(
              color: Colors.white, //background color of box
              boxShadow: [
                BoxShadow(
                    color: Colors.white70,
                    blurRadius: 10.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right 10  horizontally
                      0.0, // Move to bottom 10 Vertically
                    ))
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text("create page"),
          ),
        ));
  }
}
