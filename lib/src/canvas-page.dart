import 'package:flutter/material.dart';
import 'container-template.dart';

class CanvasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContainerWidget(Column(
      children: [RoomCode()],
    ));
  }
}

class RoomCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
      height: 40.0,
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(5.0)
      ),
    );
  }
}
