import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'src/home-page.dart';
import 'src/container-template.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SketchAndGuess());
}

class SketchAndGuess extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center();
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            final Future<UserCredential> _userCred = FirebaseAuth.instance.signInAnonymously();
            return MyApp();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center();
        }
    );
  }

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
