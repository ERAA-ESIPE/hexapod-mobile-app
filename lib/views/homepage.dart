import 'dart:math';

import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:control_pad/views/pad_button_view.dart';
import 'package:exapodpad/views/setting_view.dart';
import 'package:exapodpad/views/trame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exapodpad/services/socketservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SocketService socket;
  String _ip;
  String _port;
  final MASK = 0x1;

  double _angleToRadians(double angle) => (pi / 180) * angle;

  void _read() async {
    var prefs = await SharedPreferences.getInstance();
    final portKey = 'port';
    _port = prefs.getString(portKey) ?? 'localhost';
    final ipKey = 'address';
    _ip = prefs.getString(ipKey) ?? '8000';
    this.socket = new SocketService(_ip, int.parse(_port));
    this.socket.initSocket();
  }

  @override
  void initState() {
    super.initState();
    _read();
  }

  @override
  void dispose() {
    super.dispose();
    socket.destroy();
  }

  int buildButtonOctet(int position) {
    int n = 0x0;
    n = (n) | (MASK << position);
    return n;
  }

  _onChange(num degrees, num distance) {
    num x = distance * cos(_angleToRadians(degrees));
    num y = distance * sin(_angleToRadians(degrees));

    print('x: $x');

    print('y: $y');

    int buttons = 0;
    int leftStickX = 0;
    int leftStickY = 0;
    int rightStickX = 0;
    int rightStickY = 0;
    var trame =
        new Trame(leftStickX, leftStickY, rightStickX, rightStickY, buttons);
    socket.sendMessage(trame);
  }

  _padPressed(int buttonIndex, Gestures gesture) {
    int buttons = buildButtonOctet(buttonIndex);
    int leftStickX = 0;
    int leftStickY = 0;
    int rightStickX = 0;
    int rightStickY = 0;
    var trame =
        new Trame(leftStickX, leftStickY, rightStickX, rightStickY, buttons);
    socket.sendMessage(trame);
  }

  @override
  Widget build(BuildContext context) {
    final appBar = new AppBar(
      //elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 80, 86, 1.0),
      title: new Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    final makeBottom = new Container(
      height: 55.0,
      child: new BottomAppBar(
        color: Color.fromRGBO(58, 80, 86, 1.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            new IconButton(
              icon: Icon(Icons.settings_applications, color: Colors.white),
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(title: "Settings"),
                  ),
                );

                var splited = result?.toString()?.split(":");
                var newHost = splited[0];
                var newPort = splited[1];

                if (_ip.compareTo(newHost) != 0 ||
                    _port.compareTo(newPort) != 0) {
                  setState(() {
                    socket.destroy();
                    _read();
                  });
                } else {}
              },
            )
          ],
        ),
      ),
    );

    var componentSize = (MediaQuery.of(context).size.height / 2.5);

    var leftJoystick = new JoystickView(
      size: componentSize,
      showArrows: true,
      backgroundColor: Colors.black45,
      innerCircleColor: Colors.black12,
      onDirectionChanged: _onChange,
    );

    var rightJoystick = new JoystickView(
      size: componentSize,
      showArrows: true,
      backgroundColor: Colors.black45,
      innerCircleColor: Colors.black12,
      onDirectionChanged: _onChange,
    );

    var leftPadButton = new List<PadButtonItem>();
    leftPadButton.add(
      new PadButtonItem(
        index: 3,
        buttonImage: Image.asset("assets/right-arrow.png"),
      ),
    );
    leftPadButton.add(
      new PadButtonItem(
        index: 7,
        buttonImage: Image.asset("assets/r2.png"),
      ),
    );
    leftPadButton.add(
      new PadButtonItem(
          index: 5,
          buttonImage: Image.asset("assets/left-arrow.png"),
          buttonText: "R1"),
    );
    leftPadButton.add(
      new PadButtonItem(
        index: 4,
        buttonImage: Image.asset("assets/r1.png"),
      ),
    );

    var leftPad = new PadButtonsView(
      size: componentSize,
      backgroundPadButtonsColor: Colors.black45,
      buttons: leftPadButton,
      padButtonPressedCallback: _padPressed,
    );

    var rightPadButton = new List<PadButtonItem>();
    rightPadButton.add(
      new PadButtonItem(
        index: 0,
        buttonImage: Image.asset("assets/circle.png"),
      ),
    );
    rightPadButton.add(
      new PadButtonItem(
        index: 6,
        buttonImage: Image.asset("assets/x.png"),
      ),
    );
    rightPadButton.add(
      new PadButtonItem(
        index: 2,
        buttonImage: Image.asset("assets/square.png"),
      ),
    );
    rightPadButton.add(
      new PadButtonItem(
        index: 1,
        buttonImage: Image.asset("assets/triangle.png"),
      ),
    );

    var rightPad = new PadButtonsView(
      size: componentSize,
      backgroundPadButtonsColor: Colors.black45,
      buttons: rightPadButton,
      padButtonPressedCallback: _padPressed,
    );

    final child = new Column(
      children: <Widget>[
        new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leftPad,
            new Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
            ),
            new Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
            ),
            new Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
            ),
            new Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
            ),
            rightPad,
          ],
        ),
        new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            leftJoystick,
            new Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
            ),
            rightJoystick,
          ],
        )
      ],
    );

    return new SafeArea(
      child: new Scaffold(
        //appBar: appBar,
        body: new Container(
          //color: Color.fromRGBO(58, 66, 86, 1.0),
          color: Colors.grey,
          child: child,
        ),
        bottomNavigationBar: makeBottom,
      ),
    );
  }
}
