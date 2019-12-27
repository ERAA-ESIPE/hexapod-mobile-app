import 'dart:async';

import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:control_pad/views/pad_button_view.dart';
import 'package:hexapod/controllers/pad_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    controller = new PadController(widget.ip, int.parse(widget.port));
    Timer.periodic(
      Duration(milliseconds: PadController.interval),
      (timer) {
        controller.sendData();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final footer = new Container(
      height: 55.0,
      child: new BottomAppBar(
        color: Color.fromRGBO(58, 80, 86, 1.0),
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

    var leftJoystick = new JoystickView(
      size: componentSize,
      showArrows: true,
      backgroundColor: Colors.black45,
      innerCircleColor: Colors.black12,
      onDirectionChanged: controller.leftJoystickMove,
    );

    var rightJoystick = new JoystickView(
      size: componentSize,
      showArrows: true,
      backgroundColor: Colors.black45,
      innerCircleColor: Colors.black12,
      onDirectionChanged: controller.rightJoystickMove,
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
      padButtonPressedCallback: controller.padPressed,
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

    return new SafeArea(
      child: new Scaffold(
        bottomNavigationBar: footer,
        body: new Container(
          color: Colors.grey,
          child: _column,
          padding: EdgeInsets.all(
            8.0,
          ),
        ),
      ),
    );
  }
}
