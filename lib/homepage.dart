import 'dart:math';

import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:control_pad/views/pad_button_view.dart';
import 'package:exapodpad/setting_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exapodpad/socketservice.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final socket = new SocketService('192.168.1.24', 8000);

  String _ip, _port;

  void _read() async {
    var prefs = await SharedPreferences.getInstance();
    final portKey = 'port';
    _port = prefs.getString(portKey);
    final ipKey = 'address';
    _ip = prefs.getString(ipKey);
  }

  @override
  void initState() {
    super.initState();
    _read();
    socket.initSocket();
  }

  @override
  void dispose() {
    super.dispose();
    socket.destroy();
  }

  _onChange(num degrees, num distance) {
    num x = distance * sin(degrees);
    num y = distance * -cos(degrees);

    print("x: " + x.toString());
    print("y: " + y.toString());
  }

  _padPressed(int buttonIndex, Gestures gesture) {
    print('read: $_ip');
    print('read: $_port');
    socket.sendMessage("toto");
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _read();
    });

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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(title: "Settings")),
                );
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
          index: 1,
          buttonImage: Image.asset("assets/l1.png"),
          buttonText: "L1"),
    );
    leftPadButton.add(
      new PadButtonItem(
          index: 2,
          buttonImage: Image.asset("assets/r2.png"),
          buttonText: "L2"),
    );
    leftPadButton.add(
      new PadButtonItem(
          index: 3,
          buttonImage: Image.asset("assets/l2.png"),
          buttonText: "R1"),
    );
    leftPadButton.add(
      new PadButtonItem(
          index: 4,
          buttonImage: Image.asset("assets/r1.png"),
          buttonText: "R2"),
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
        index: 5,
        buttonImage: Image.asset("assets/circle.png"),
        buttonText: "Y",
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
        index: 7,
        buttonImage: Image.asset("assets/square.png"),
      ),
    );
    rightPadButton.add(
      new PadButtonItem(
        index: 8,
        buttonImage: Image.asset("assets/triangle.png"),
        buttonText: "Y",
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
