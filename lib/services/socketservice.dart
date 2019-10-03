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
    /* Read host and port from local storage */

    this.socket = await _getSocket();
  }

  void sendMessage(String message) {
    this.socket.write(message);
  }

  void destroy() {
    this.socket.close();
  }
}
