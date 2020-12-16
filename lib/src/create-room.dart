import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'canvas-page.dart';
import 'buttons.dart';
import 'container-template.dart';
import 'package:my_app/globals.dart' as globals;

class CreateRoom extends StatefulWidget {
  const CreateRoom({Key key}) : super(key: key);

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  
  final nameController = TextEditingController();
  final collectionRef = FirebaseFirestore.instance.collection('rooms');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
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

  unFocusTextField (BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  addDocumentToDatabase (String roomcode, BuildContext context) {
    collectionRef.doc(roomcode).set({'participants': [globals.name], 'messages': [], 'paintBrushes': []}).then((value) => {
      globals.roomcode = roomcode,
      Navigator.of(context).push(_createRoute(CanvasPage()))
    }).catchError((onError) => {
      print("Error adding document")
    });
  }

  createFirebaseDocument(BuildContext context) async {
    List<String> documentList = [];
    String roomcode = "";
    QuerySnapshot documents = await collectionRef.get();
    for (QueryDocumentSnapshot doc in documents.docs) {
      documentList.add(doc.id);
    }
    while (roomcode == "" || documentList.contains(roomcode)) {
      roomcode = generateRandomString(6);
    }
    addDocumentToDatabase(roomcode, context);
  }

  createNewRoom(BuildContext context) {
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
    } else {
      globals.name = nameController.text;
      createFirebaseDocument(context);
    }
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
        Builder(builder: (BuildContext context) {
          return HomeButton("CREATE", (() => {
            createNewRoom(context)
          }));
        }),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    )));
  }
}
