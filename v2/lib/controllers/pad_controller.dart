import 'package:hexapod/services/socketservice.dart';

class PadController {
  final String host;
  final int port;
  SocketService socketService;

  PadController(this.host, this.port) {
    this.socketService = new SocketService(host, port);
  }

  dispose() {}
}
