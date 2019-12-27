import 'package:control_pad/models/gestures.dart';
import 'package:hexapod/services/socketservice.dart';
import 'dart:math';

class PadController {
  final String host;
  final int port;
  static final int mask = 0x1;
  static final int interval = 100; // Send trame each 100ms
  static final int radix = 16;
  final int nopeOctet = 0x0;
  final int startAndEndOctet = 0xFF;
  final int modulo = 235;

  int leftStickX;
  int leftStickY;
  int rightStickX;
  int rightStickY;
  int buttons;

  SocketService socketService;

  PadController(this.host, this.port) {
    this.socketService = new SocketService(host, port);
    this.leftStickX = 0;
    this.leftStickY = 0;
    this.rightStickX = 0;
    this.rightStickY = 0;
    this.buttons = 0;
  }

  padPressed(int buttonIndex, Gestures gesture) {
    buttons = _buildButtonOctet(buttonIndex);
  }

  rightJoystickMove(double degrees, double distance) {
    var result = _joystickMove(degrees, distance);
    rightStickX = result[0];
    rightStickY = result[1];
  }

  leftJoystickMove(double degrees, double distance) {
    var result = _joystickMove(degrees, distance);
    leftStickX = result[0];
    leftStickY = result[1];
  }

  dispose() {
    socketService?.destroy();
    _bzero();
    socketService = null;
  }

  sendData() {
    socketService?.sendMessage(_buildMessage());
    _bzero();
  }

  String _buildMessage() {
    var separator = ';';
    var buffer = new StringBuffer();
    buffer.write(startAndEndOctet.toRadixString(radix));
    buffer.write(separator);

    buffer.write(leftStickX.toRadixString(radix));
    buffer.write(separator);

    buffer.write(leftStickY.toRadixString(radix));
    buffer.write(separator);

    buffer.write(rightStickX.toRadixString(radix));
    buffer.write(separator);

    buffer.write(rightStickY.toRadixString(radix));
    buffer.write(separator);

    buffer.write(buttons.toRadixString(radix));
    buffer.write(separator);

    buffer.write(nopeOctet.toRadixString(radix));
    buffer.write(separator);

    buffer.write(startAndEndOctet.toRadixString(radix));
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
    int y = (((distance * cos(_angleToRadians(degrees))) * modulo) % modulo)
        .toInt();
    int x = (((distance * sin(_angleToRadians(degrees))) * modulo) % modulo)
        .toInt();
    return [x, y];
  }

  /* Re-initalize all fields */
  _bzero() {
    this.leftStickX = 0;
    this.leftStickY = 0;
    this.rightStickX = 0;
    this.rightStickY = 0;
    this.buttons = 0;
  }
}
