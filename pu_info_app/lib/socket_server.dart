import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'models/server_model.dart';

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
    Server curServer = serBox.getAt(id)!;
    _socket?.dispose();
    _socket = IO.io(
      "http://${curServer.ipAddress}",
      IO.OptionBuilder().setTransports(["websocket"]).enableForceNew().build(),
    );
    socket.onConnect((_) {
      curServer.isConnected = true;
      serBox.putAt(id, curServer);
      if (curServer.macAddress == null) {
        socket.emitWithAck("getMac", "", ack: (String macAddress) {
          curServer.macAddress = macAddress;
          serBox.putAt(id, curServer);
        });
      } else {
        socket.emitWithAck("getMac", "", ack: (String macAddress) {
          if (curServer.macAddress != macAddress) {
            _socket?.dispose();
            throw Exception(
                "Sorry this server is already rigister to this mac: $macAddress");
          }
        });
      }
    });
    if (serverId != null) {
      Server preServer = serBox.getAt(serverId!)!;
      preServer.isConnected = false;
      serBox.putAt(serverId!, preServer);
    }

    serverId = id;
  }

  IO.Socket get socket => _socket!;
  static init(int id) {
    if (_instance == null) {
      throw ArgumentError(
          "Socket Server must be initialized first. ", "SocketService");
    }
    SocketService(id)._init(id);
  }
}
