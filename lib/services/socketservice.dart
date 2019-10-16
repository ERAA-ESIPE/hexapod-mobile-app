import 'dart:io';

class SocketService {
  Socket socket;
  String host;
  int port;

  SocketService(String host, int port) {
    this.host = host;
    this.port = port;
  }

  Future<Socket> _getSocket() async {
    return await Socket.connect(host, port);
  }

  void initSocket() async {
    socket = await _getSocket();
    socket.setOption(SocketOption.tcpNoDelay, true);
  }

  void sendMessage(String message) {
    socket.write(message);
    socket.writeln();
  }

  void destroy() {
    socket.close();
  }
}
