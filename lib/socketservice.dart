import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/socket.dart';

class Socket {
  SocketIO socket;
  String channel;

  _getSocket(String host, int port) async {
    var socket = await SocketIOManager()
        .createInstance(new SocketOptions("http://${host}:${port}"));
    return socket.connect();
  }

  Socket(String host, int port, String channel) {
    this.socket = _getSocket(host, port);
    this.channel = channel;

    this.socket.onConnect((data) {
      print("connected...");
      print(data);
    });

    this.socket.on(channel, (data) {
      print("channel");
      print(data);
    });

    socket.connect();
  }

  sendMessage(String eventName, List messages) {
    this.socket.emit(eventName, messages);
  }

  destroy() {
    this.socket.off(this.channel, (listener) {
      print("unsouscried ${this.channel}");
    });
  }
}
