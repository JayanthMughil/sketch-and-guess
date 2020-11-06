import 'package:flutter/material.dart';

class DrawArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Expanded(
        child: Container(
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            borderRadius: BorderRadius.circular(5.0)
          ),
        )
      );
  }
}
