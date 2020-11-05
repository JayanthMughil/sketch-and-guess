import 'package:flutter/material.dart';
import 'buttons.dart';
import 'create-room.dart';
import 'join-room.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new HomeButton("CREATE ROOM", new CreateRoom()),
        new HomeButton("JOIN ROOM", new JoinRoom())
      ],
    );
  }
}
