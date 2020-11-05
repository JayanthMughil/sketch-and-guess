import 'package:flutter/material.dart';
import 'create-room.dart';

class HomeButton extends StatelessWidget {
  final String btnName;
  final dynamic className;

  const HomeButton(this.btnName, this.className);

  Route _createRoute() {
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
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(_createRoute());
        },
        child: Text(btnName,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            elevation: MaterialStateProperty.all<double>(10),
            minimumSize: MaterialStateProperty.all<Size>(Size(140, 40))));
  }
}
