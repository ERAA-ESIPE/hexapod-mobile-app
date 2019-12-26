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
    socket = await Socket.connect(host, port);
    //socket.setOption(SocketOption.tcpNoDelay, true);
  }

  void sendMessage(String message) {
    var msg = utf8.encode(message);
    socket.write(msg);
  }

  void sendRawMessage(List<int> ints) {
    socket.writeAll(ints);
  }

  void destroy() {
    socket.close();
  }
}
