import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final dynamic childWidget;

  ContainerWidget(this.childWidget);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
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
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: childWidget,
          ),
        )));
  }
}
