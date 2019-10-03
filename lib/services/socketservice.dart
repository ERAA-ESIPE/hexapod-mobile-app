import 'dart:io';

class SocketService {
  String host;
  int port;
  Socket socket;

  Future<Socket> _getSocket(String host, int port) async {
    return await Socket.connect(host, port);
  }

  SocketService(String host, int port) {
    this.host = host;
    this.port = port;
  }

  void initSocket() async {
    this.socket = await _getSocket(host, port);
  }

  void sendMessage(String message) {
    this.socket.write(message);
  }

  void destroy() {
    this.socket.close();
  }
}
