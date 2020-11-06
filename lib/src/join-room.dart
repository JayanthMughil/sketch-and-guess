import 'package:flutter/material.dart';
import 'container-template.dart';
import 'buttons.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({Key key}) : super(key: key);

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  @override
  Widget build(BuildContext context) {
    return ContainerWidget(Column(
      children: [
        Material(
         color: Colors.white,
         child: Container(
            margin: const EdgeInsets.only(
              left: 40.0,
              right: 40.0
            ),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter room code',
                fillColor: Colors.white
              ),
              maxLines: 1,
            )
          )
        ),
        SizedBox(height: 20,),
        HomeButton("JOIN", null)
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }
}
