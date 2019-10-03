import 'dart:io';

class SocketService {
  String host;
  int port;
  Socket socket;

  Future<Socket> _getSocket(String host, int port) async {
    var result = await Socket.connect(host, port);
    return result;
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


  void destroy(){
    this.socket.close();
  }
}
