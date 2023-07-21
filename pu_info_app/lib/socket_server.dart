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

  // Private constructor
  SocketService._internal(int? index) {
    if (index != null) {
      _init(index);
    }
  }
  // Initialize the socket connection and event handlers
  void _init(int id) {
    // Access the Hive boxes for server data and previous session
    Box<Server> serBox = Hive.box<Server>('server');
    Box<int> prevSess = Hive.box(kPrevSess);
    Server curServer = serBox.getAt(id)!;

    // Dispose any existing socket before creating a new one
    _socket?.dispose();

    // Create a new socket instance with options for the connection
    _socket = IO.io(
      'http://${curServer.ipAddress}',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setReconnectionDelay(200)
          .setReconnectionAttempts(5)
          .build(),
    );

    // Set up event handler for socket connection
    _socket?.onConnect((_) {
      // Update server status and store the current session ID
      curServer.isConnected = true;
      prevSess.put(kPrevSessKey, id);
      serBox.putAt(id, curServer);

      // If the MAC address is not available, get it from the server
      if (curServer.macAddress == null) {
        _getMacAddress(id, serBox);
      } else {
        // If the MAC address is available, check if it matches the server's MAC
        _checkMacAddress(id, curServer.macAddress!);
      }
    });
    // Set up event handler for socket reconnection failure
    _socket!.onReconnectFailed((_) {
      _socket?.dispose();
    });

    // Set up event handler for socket disconnection
    _socket!.onDisconnect((_) {
      // Update server status when disconnected
      Server preServer = serBox.getAt(id)!;
      preServer.isConnected = false;
      serBox.putAt(id, preServer);
    });

    // Store the current server ID for reference
    serverId = id;
  }

  // Get the socket instance
  static IO.Socket? get socket => SocketService()._socket;

  // Send a request to get the MAC address from the server
  void _getMacAddress(int id, Box<Server> serBox) {
    _socket?.emitWithAck('getMac', '', ack: (String macAddress) {
      // Update the server's MAC address in the Hive box
      Server curServer = serBox.getAt(id)!;
      curServer.macAddress = macAddress;
      serBox.putAt(id, curServer);
    });
  }

  // Check if the server's MAC address matches the response from the server
  void _checkMacAddress(int id, String macAddress) {
    _socket?.emitWithAck('getMac', '', ack: (String responseMac) {
      if (macAddress != responseMac) {
        // If the MAC address does not match, dispose of the socket and throw an exception
        _socket?.dispose();
        throw Exception(
            'Sorry, this server is already registered to this MAC: $responseMac');
      }
    });
  }

  // Initialize the socket service with a server ID
  static init(int id) {
    if (_instance == null) {
      throw ArgumentError(
          'Socket Server must be initialized first. ', 'SocketService');
    }
    SocketService(id)._init(id);
  }
}
