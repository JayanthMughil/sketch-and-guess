import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/src/canvas-page.dart';
import 'package:my_app/globals.dart' as globals;
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
  final collectionRef = FirebaseFirestore.instance.collection('rooms');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    codeController.dispose();
    super.dispose();
  }

  unFocusTextField (BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  joinRoom (BuildContext context) {
    if (nameController.text == "") {
      unFocusTextField(context);
      Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.blueAccent,
      elevation: 10.0,
      content: Text(
      "Please enter a name",
      style: TextStyle(color: Colors.white),
      ),
      ));
    } else if (codeController.text == "") {
      unFocusTextField(context);
      Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.blueAccent,
      elevation: 10.0,
      content: Text(
      "Please enter a room code",
      style: TextStyle(color: Colors.white),
      ),
      ));
    } else {
      collectionRef.doc(codeController.text).update(
          {'participants': FieldValue.arrayUnion([nameController.text])}).then((value) =>
            {
              globals.name = nameController.text,
              globals.roomcode = codeController.text,
              Navigator.of(context).push(_createRoute(CanvasPage()))
            }).catchError((onError) =>
            {
              unFocusTextField(context),
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.blueAccent,
                elevation: 10.0,
                content: Text(
                  "Wrong room code entered",
                  style: TextStyle(color: Colors.white),
                ),
              ))
            });
    }
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
    return Scaffold(body: ContainerWidget(Column(
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
        Builder(builder: (BuildContext context) {
          return HomeButton("JOIN", (() => {
            joinRoom(context)
          }));
        })
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    )));
  }
}
