import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String btnName;
  final Function func;

  const HomeButton(this.btnName, this.func);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: func,
        child: Text(btnName,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            elevation: MaterialStateProperty.all<double>(10),
            minimumSize: MaterialStateProperty.all<Size>(Size(140, 40))));
  }
}
