import 'package:hive/hive.dart';

part 'server_model.g.dart';

@HiveType(typeId: 1)
class Server {
  Server(
      {required this.name,
      required this.ipAddress,
      this.macAddress,
      this.isConnected = false});
  @HiveField(0)
  String name;

  @HiveField(1)
  String ipAddress;

  @HiveField(2)
  String? macAddress;

  bool isConnected;

  @override
  String toString() {
    return "Server = name:${name.toString()}, ip:${ipAddress.toString()}, mac:${macAddress.toString()}";
  }

  Server copyWith({String? mac, bool? isConnect}) {
    return Server(
        name: name,
        ipAddress: ipAddress,
        macAddress: mac ?? macAddress,
        isConnected: isConnect ?? isConnected);
  }
}
