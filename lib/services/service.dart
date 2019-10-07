import 'package:flutter_socket_plugin/flutter_socket.dart';

class Service {
  FlutterSocket socket;
  String host;
  int port;

  Service(String host, int port) {
    this.host = host;
    this.port = port;
    this.socket = new FlutterSocket();
  }

  Future _getSocket() async {
    return await socket.createSocket(host, port, timeout: 0);
  }

  void initSocket() async {
    _getSocket();
    socket
        .tryConnect()
        .then((result) => print('connected'))
        .catchError((err) => print('connection error: $err'));

    socket.connectListener((data) {
      print('connect listener data:$data');
    });

    socket.errorListener((data) {
      print('error listener data:$data');
    });

    socket.receiveListener((data) {
      print('receive listener data:$data');
    });
  }

  void sendMessage(String message) {
    socket
        .send(message)
        .then((result) => print('Sended'))
        .catchError((err) => print('error send message: $err'));
  }

  void destroy() {
    socket
        .tryDisconnect()
        .then((data) => print('Socket disconnected'))
        .catchError((err) => print('error disconnected: $err'));
  }
}
