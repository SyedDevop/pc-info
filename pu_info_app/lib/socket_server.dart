import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/server_model.dart';

class SocketService {
  static SocketService? _instance;
  late IO.Socket _socket;
  static bool isInitialized = false;
  static Server? connectedServer;

  factory SocketService(Server? server, int? index) {
    if (_instance == null) {
      if (server == null) {
        throw ArgumentError(
            'URL must be provided on first initialization of the Socket');
      }
      _instance = SocketService._internal(server, index ?? 0);
    }
    return _instance!;
  }

  SocketService._internal(Server server, int index) {
    // initialization logic here
    print("Trigeard");
    if (connectedServer != null) {
      _socket.dispose();
      print(_socket);
    }
    _socket = IO.io(
      "http://${server.ipAddress}",
      IO.OptionBuilder().setTransports(["websocket"]).build(),
    );
    _socket.onConnect((_) {
      isInitialized = true;
      Server newServe = server.copyWith(isConnect: true);
      Box<Server> serBox = Hive.box<Server>("server");
      serBox.putAt(index, newServe);
      if (server.macAddress == null) {
        _socket.emitWithAck("getMac", "", ack: (String macAddress) {
          Server newServe = server.copyWith(mac: macAddress);
          serBox.putAt(index, newServe);
          connectedServer = newServe;
        });
      }
    });
  }

  void StartNewSocket(int index) {
    if (connectedServer != null) {
      _socket.dispose();
      print(_socket);
    }
  }

  IO.Socket get socket => _socket;
}
