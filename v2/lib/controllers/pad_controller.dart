import 'package:control_pad/models/gestures.dart';
import 'package:hexapod/services/socketservice.dart';
import 'dart:math';

class PadController {
  final String host;
  final int port;

  static final int mask = 0x1;
  static final int interval = 100; // Send trame each 100ms

  SocketService socketService;

  PadController(this.host, this.port) {
    this.socketService = new SocketService(host, port);
  }

  double _angleToRadians(double angle) => (pi / 180) * angle;

  int _buildButtonOctet(int position) {
    int n = 0x0;
    n = (n) | (mask << (position));
    print('n: $n');
    return n;
  }

  dispose() {
    socketService?.destroy();
  }

  rightJoystickMove() {}

  padPressed(int buttonIndex, Gestures gesture) {
    int buttons = _buildButtonOctet(buttonIndex);
    //var trame = new Trame(0, 0, 0, 0, buttons);
    //  socket.sendMessage(trame.toString());
    //print('stringqcssq:' + trame.toString());
  }

  leftJoystickMove() {}
}
