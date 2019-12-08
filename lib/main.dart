import 'package:exapodpad/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  ).then((onValue) => runApp(new MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HexapodPad',
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
      ),
      home: new HomePage(title: "Hexapod"),
      debugShowCheckedModeBanner: false,
    );
  }
}
