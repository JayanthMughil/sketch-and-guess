import 'package:flutter/material.dart';
import 'package:my_app/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';

class TextArea extends StatefulWidget {

  const TextArea({Key key}): super(key: key);

  @override
  _TextArea createState() => _TextArea();

}

class _TextArea extends State<TextArea> {

  final msgcontroller = TextEditingController();
  final collectionRef = FirebaseFirestore.instance.collection('rooms');
  List<dynamic> messages = [];

  @override
  void initState() {
    collectionRef.doc(globals.roomcode).get().then((docs) => {
      setState(() {
        messages = docs.get('messages');
      })
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    collectionRef.doc(globals.roomcode).update({'participants': FieldValue.arrayRemove([globals.name])}).then((value) => {
      globals.roomcode = ""
    });
    msgcontroller.dispose();
    super.dispose();
  }

  sendMessage() async {
    setState(() {
      messages.insert(0, {'name': globals.name, 'text': msgcontroller.text});
      msgcontroller.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Material(
                        child: Container(
                        margin: EdgeInsets.all(5.0),
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 2.0), //(x,y)
                              blurRadius: 3.0,
                            )
                          ]
                        ),
                        child: TextField(
                          controller: msgcontroller,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 6, bottom: 6),
                            fillColor: Colors.white,
                            hintText: "Type your answer here",
                            border: InputBorder.none
                          )
                        ),
                      )
                    )
                  ),
                  Container(
                    height: 40.0,
                    width: 40.0,
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: IconButton(
                      padding: EdgeInsets.only(top: 2.0),
                      icon: Icon(
                        Icons.send,
                        color: Colors.blueAccent,
                        size: 35,
                      ),
                      onPressed: sendMessage,
                    ),
                  )
                ]
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 3.0), //(x,y)
                          blurRadius: 3.0,
                        )
                      ]
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(5.0),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 35.0,
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 0.6, color: Colors.grey)
                            )
                          ),
                          child: Text(messages[index]['name'] + ": " + messages[index]['text'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    ),
                  )
              )
            ],
          ),
        )
      );
  }
}
