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
    this.socket = await _getSocket();
  }

  void sendMessage(String message) {
    this.socket.setOption(SocketOption.tcpNoDelay, true);
    this.socket.write(message + '\n');
  }

  void destroy() {
    this.socket.close();
  }
}
