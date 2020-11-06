import 'package:flutter/material.dart';
import 'package:my_app/src/canvas-page.dart';
import 'container-template.dart';
import 'buttons.dart';
import 'canvas-page.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({Key key}) : super(key: key);

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {

  final nameController = TextEditingController();
  final codeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    codeController.dispose();
    super.dispose();
  }

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
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Enter name',
                      fillColor: Colors.white
                  ),
                  maxLines: 1,
                )
            )
        ),
        SizedBox(height: 20,),
        Material(
         color: Colors.white,
         child: Container(
            margin: const EdgeInsets.only(
              left: 40.0,
              right: 40.0
            ),
            child: TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Enter room code',
                fillColor: Colors.white
              ),
              maxLines: 1,
            )
          )
        ),
        SizedBox(height: 20,),
        HomeButton("JOIN", (() => {
          Navigator.of(context).push(_createRoute(CanvasPage()))
        }))
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }
}
