import 'dart:io';
import 'dart:convert';

class SocketService {
  Socket socket;
  String host;
  int port;

  SocketService(String host, int port) {
    this.host = host;
    this.port = port;
    _initSocket();
  }

  void _initSocket() async {
    try {
      socket = await Socket.connect(host, port);
      //socket.setOption(SocketOption.tcpNoDelay, true);
    } on SocketException catch (e) {
      throw new AssertionError(e);
    }
  }

  void sendMessage(String message) {
    var msg = utf8.encode(message);
    socket?.add(msg);
  }

  void destroy() {
    socket?.close();
  }
}
