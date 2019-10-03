import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SocketService {
  Socket socket;

  Future<Socket> _getSocket(String host, int port) async {
    return await Socket.connect(host, port);
  }

  void initSocket() async {
    /* Read host and port from local storage */
    var prefs = await SharedPreferences.getInstance();
    prefs.reload();
    final portKey = 'port';
    final port = int.parse(prefs.getString(portKey));
    final ipKey = 'address';
    final host = prefs.getString(ipKey);

    this.socket = await _getSocket(host, port);
  }

  void sendMessage(String message) {
    this.socket.write(message);
  }

  void destroy() {
    this.socket.close();
  }
}
