import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'buttons.dart';
import 'create-room.dart';
import 'join-room.dart';

class HomePage extends StatelessWidget {

  Route _createRoute(dynamic className) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => className,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HomeButton("CREATE ROOM", (() {
          Navigator.of(context).push(_createRoute(CreateRoom()));
        })),
        HomeButton("JOIN ROOM", (() {
          Navigator.of(context).push(_createRoute(JoinRoom()));
        }))
      ],
    );
  }
}
