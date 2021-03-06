import 'dart:async';
import 'dart:io';

import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:control_pad/views/pad_button_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexapod/controllers/pad_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexapod/views/error_view.dart';

class PadView extends StatefulWidget {
  PadView({Key key, this.title, this.ip, this.port}) : super(key: key);

  final String title;
  final String ip;
  final String port;

  @override
  _PadViewState createState() => _PadViewState();
}

class _PadViewState extends State<PadView> {
  PadController controller;
  Socket socket;
  final Color _color = Color.fromARGB(255, 16, 88, 102);
  final Color _backgroundColor = Color.fromARGB(255, 220, 220, 220);

  @override
  void initState() {
    super.initState();
    controller = new PadController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    socket.flush();
    socket.destroy();
  }

  @override
  Widget build(BuildContext context) {
    final footer = new Container(
      height: 55.0,
      child: new BottomAppBar(
        color: _color,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                controller.dispose();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );

    var componentSize = (MediaQuery.of(context).size.height / 2.8);

    var supportedGestures = [
      Gestures.TAP,
      Gestures.LONGPRESSSTART,
      Gestures.LONGPRESSUP,
    ];

    var leftJoystick = new JoystickView(
      size: componentSize + 10,
      showArrows: true,
      backgroundColor: Colors.black45,
      innerCircleColor: Colors.black12,
      onDirectionChanged: controller.leftJoystickMove,
      interval: Duration(milliseconds: PadController.interval),
    );

    var rightJoystick = new JoystickView(
      size: componentSize + 10,
      showArrows: true,
      backgroundColor: Colors.black45,
      innerCircleColor: Colors.black12,
      onDirectionChanged: controller.rightJoystickMove,
      interval: Duration(milliseconds: PadController.interval),
    );

    var leftPadButton = new List<PadButtonItem>();
    leftPadButton.add(
      new PadButtonItem(
        index: 3,
        buttonImage: Image.asset("assets/right-chevron.png"),
        supportedGestures: supportedGestures,
      ),
    );
    leftPadButton.add(
      new PadButtonItem(
        index: 7,
        buttonImage: Image.asset("assets/down-chevron.png"),
        supportedGestures: supportedGestures,
      ),
    );
    leftPadButton.add(
      new PadButtonItem(
        index: 5,
        buttonImage: Image.asset("assets/left-chevron.png"),
        supportedGestures: supportedGestures,
      ),
    );
    leftPadButton.add(
      new PadButtonItem(
        index: 4,
        buttonImage: Image.asset("assets/up-chevron.png"),
        supportedGestures: supportedGestures,
      ),
    );

    var leftPad = new PadButtonsView(
      size: componentSize,
      backgroundPadButtonsColor: Colors.black45,
      buttons: leftPadButton,
      padButtonPressedCallback: controller.padPressed,
    );

    var rightPadButton = new List<PadButtonItem>();
    rightPadButton.add(
      new PadButtonItem(
        index: 0,
        buttonImage: Image.asset("assets/circle.png"),
        supportedGestures: supportedGestures,
      ),
    );
    rightPadButton.add(
      new PadButtonItem(
        index: 6,
        buttonImage: Image.asset("assets/x.png"),
        supportedGestures: supportedGestures,
      ),
    );
    rightPadButton.add(
      new PadButtonItem(
        index: 2,
        buttonImage: Image.asset("assets/square.png"),
        supportedGestures: supportedGestures,
      ),
    );
    rightPadButton.add(
      new PadButtonItem(
        index: 1,
        buttonImage: Image.asset("assets/triangle.png"),
        supportedGestures: supportedGestures,
      ),
    );

    var rightPad = new PadButtonsView(
      size: componentSize,
      backgroundPadButtonsColor: Colors.black45,
      buttons: rightPadButton,
      padButtonPressedCallback: controller.padPressed,
    );

    final _column = new Column(
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

    final _child = new FutureBuilder(
      future: Socket.connect(
        widget.ip,
        int.parse(widget.port),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new ErrorView();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && (snapshot.data != null)) {
            socket = snapshot.data;
            Timer.periodic(
              Duration(milliseconds: PadController.interval),
              (timer) {
                var trame = controller.getTrame();
                //print(trame);
                socket.add(trame);
              },
            );
            return _column;
          } else {
            return new ErrorView();
          }
        } else {
          return new SpinKitDoubleBounce(
            color: _color,
          );
        }
      },
    );

    return new SafeArea(
      child: new Scaffold(
        bottomNavigationBar: footer,
        body: new Container(
          color: _backgroundColor,
          child: _child,
          padding: EdgeInsets.all(
            8.0,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
