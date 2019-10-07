import 'dart:math';

import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:control_pad/views/pad_button_view.dart';
import 'package:exapodpad/services/service.dart';
import 'package:exapodpad/views/setting_view.dart';
import 'package:exapodpad/views/trame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Service socket;

  String _ip;
  String _port;
  final int mask = 0x1;
  final int interval = 100; // Send trame each 100ms

  double _angleToRadians(double angle) => (pi / 180) * angle;

  void _read() async {
    var prefs = await SharedPreferences.getInstance();
    final portKey = 'port';
    _port = prefs.getString(portKey);
    final ipKey = 'address';
    _ip = prefs.getString(ipKey);
    if (_port != null && _ip != null) {
      socket = new Service(_ip, int.parse(_port));
      socket.initSocket();
    }
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
    n = (n) | (mask << (8 - position));
    return n;
  }

  _leftJoystickMove(num degrees, num distance) {
    num y = distance * cos(_angleToRadians(degrees));
    num x = distance * sin(_angleToRadians(degrees));

    print('dist: $distance ; degrees: $degrees');
    print('x: $x ; y: $y');

    int leftStickX = x;
    int leftStickY = y;
    var trame = new Trame(leftStickX, leftStickY, 0, 0, 0);
    socket.sendMessage(trame.toString());
  }

  _rightJoystickMove(num degrees, num distance) {
    num y = distance * cos(_angleToRadians(degrees));
    num x = distance * sin(_angleToRadians(degrees));

    print('dist: $distance ; degrees: $degrees');
    print('x: $x ; y: $y');

    int rightStickX = x;
    int rightStickY = y;
    var trame = new Trame(0, 0, rightStickX, rightStickY, 0);
    socket.sendMessage(trame.toString());
  }

  _padPressed(int buttonIndex, Gestures gesture) {
    int buttons = buildButtonOctet(buttonIndex);
    var trame = new Trame(0, 0, 0, 0, buttons);
    socket.sendMessage(trame.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                    if (this.socket != null) {
                      this.socket.destroy();
                    }
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
      onDirectionChanged: _leftJoystickMove,
      interval: Duration(
        microseconds: interval,
      ),
    );

    var rightJoystick = new JoystickView(
      size: componentSize,
      showArrows: true,
      backgroundColor: Colors.black45,
      innerCircleColor: Colors.black12,
      onDirectionChanged: _rightJoystickMove,
      interval: Duration(
        microseconds: interval,
      ),
    );

    var leftPadButton = new List<PadButtonItem>();
    leftPadButton.add(
      new PadButtonItem(
        index: 3,
        buttonImage: Image.asset("assets/right-chevron.png"),
      ),
    );
    leftPadButton.add(
      new PadButtonItem(
        index: 7,
        buttonImage: Image.asset("assets/down-chevron.png"),
      ),
    );
    leftPadButton.add(
      new PadButtonItem(
          index: 5,
          buttonImage: Image.asset("assets/left-chevron.png"),
          buttonText: "R1"),
    );
    leftPadButton.add(
      new PadButtonItem(
        index: 4,
        buttonImage: Image.asset("assets/up-chevron.png"),
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
