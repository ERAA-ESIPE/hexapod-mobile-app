import 'dart:convert';

import 'package:control_pad/models/gestures.dart';
import 'dart:math';

class PadController {
  static final int mask = 0x1;
  static final int interval = 100; // Send trame each 100ms
  static final int radix = 16;
  final int _nopeOctet = 0x0;
  final int _startAndEndOctet = 0xFF;
  final int _modulo = 235;

  int _leftStickX;
  int _leftStickY;
  int _rightStickX;
  int _rightStickY;
  int _buttons;
  bool _longPressPad;

  PadController() {
    this._leftStickX = 0;
    this._leftStickY = 0;
    this._rightStickX = 0;
    this._rightStickY = 0;
    this._buttons = 0;
    this._longPressPad = false;
  }

  padPressed(int buttonIndex, Gestures gesture) {
    _longPressPad = (gesture == Gestures.LONGPRESSSTART);
    _buttons = _buildButtonOctet(buttonIndex);
    if (gesture == Gestures.LONGPRESSUP) {
      _longPressPad = false;
    }
  }

  rightJoystickMove(double degrees, double distance) {
    var result = _joystickMove(degrees, distance);
    _rightStickX = result[0];
    _rightStickY = result[1];
  }

  leftJoystickMove(double degrees, double distance) {
    var result = _joystickMove(degrees, distance);
    _leftStickX = result[0];
    _leftStickY = result[1];
  }

  dispose() {
    _bzero();
  }

  getTrame() {
    var msg = _buildMessage();
    if (!_longPressPad) {
      _bzeroPad();
    }
    return utf8.encode(msg);
  }

  /* Re-initalize all fields */
  _bzero() {
    this._leftStickX = 0;
    this._leftStickY = 0;
    this._rightStickX = 0;
    this._rightStickY = 0;
    this._buttons = 0;
  }

  _bzeroPad() {
    this._buttons = 0;
  }

  String _buildMessage() {
    var separator = ';';
    var buffer = new StringBuffer();
    buffer.write(_startAndEndOctet.toRadixString(radix));
    buffer.write(separator);

    buffer.write(_leftStickX.toRadixString(radix));
    buffer.write(separator);

    buffer.write(_leftStickY.toRadixString(radix));
    buffer.write(separator);

    buffer.write(_rightStickX.toRadixString(radix));
    buffer.write(separator);

    buffer.write(_rightStickY.toRadixString(radix));
    buffer.write(separator);

    buffer.write(_buttons.toRadixString(radix));
    buffer.write(separator);

    buffer.write(_nopeOctet.toRadixString(radix));
    buffer.write(separator);

    buffer.write(_startAndEndOctet.toRadixString(radix));
    buffer.writeln();
    return buffer.toString().toUpperCase();
  }

  double _angleToRadians(double angle) => (pi / 180) * angle;

  int _buildButtonOctet(int position) {
    int n = 0x0;
    n = (n) | (mask << (position));
    print('n: $n');
    return n;
  }

  List<int> _joystickMove(double degrees, double distance) {
    int y = (((distance * cos(_angleToRadians(degrees))) * _modulo) % _modulo)
        .toInt();
    int x = (((distance * sin(_angleToRadians(degrees))) * _modulo) % _modulo)
        .toInt();
    return [x, y];
  }
}
