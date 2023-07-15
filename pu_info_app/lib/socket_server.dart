import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/server_model.dart';
import 'const.dart';

class SocketService {
  static SocketService? _instance;
  IO.Socket? _socket;
  int? serverId;

  factory SocketService([int? index]) {
    _instance ??= SocketService._internal(index);
    return _instance!;
  }

  SocketService._internal(int? index) {
    if (index != null) {
      _init(index);
    }
  }
  void _init(int id) {
    Box<Server> serBox = Hive.box<Server>("server");
    Box<int> prevSess = Hive.box(kPrevSess);
    Server curServer = serBox.getAt(id)!;
    _socket?.dispose();
    _socket = IO.io(
      "http://${curServer.ipAddress}",
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .enableForceNew()
          .setReconnectionDelay(1000)
          .setReconnectionAttempts(5)
          .build(),
    );
    _socket?.onConnect((e) {
      curServer.isConnected = true;
      prevSess.put(kPrevSessKey, id);
      serBox.putAt(id, curServer);
      if (curServer.macAddress == null) {
        _socket?.emitWithAck("getMac", "", ack: (String macAddress) {
          curServer.macAddress = macAddress;
          serBox.putAt(id, curServer);
        });
      } else {
        _socket?.emitWithAck("getMac", "", ack: (String macAddress) {
          if (curServer.macAddress != macAddress) {
            _socket?.dispose();
            throw Exception(
                "Sorry this server is already rigister to this mac: $macAddress");
          }
        });
      }
    });
    _socket!.onDisconnect((_) {
      if (serverId != null) {
        Server preServer = serBox.getAt(serverId!)!;
        preServer.isConnected = false;
        serBox.putAt(serverId!, preServer);
      }
    });
    serverId = id;
  }

  static IO.Socket? get socket => SocketService()._socket;

  static init(int id) {
    if (_instance == null) {
      throw ArgumentError(
          "Socket Server must be initialized first. ", "SocketService");
    }
    SocketService(id)._init(id);
  }
}
