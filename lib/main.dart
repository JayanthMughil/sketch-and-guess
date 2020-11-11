import 'package:flutter/material.dart';
import 'src/home-page.dart';
import 'src/container-template.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              backgroundColor: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: MyHomePage(),
        );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContainerWidget(HomePage());
  }
}
