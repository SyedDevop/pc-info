import 'package:hive/hive.dart';

part 'server_model.g.dart';

@HiveType(typeId: 1)
class Server {
  Server(
      {required this.name,
      required this.ipAddress,
      this.macAddress = "--.--.--.--.--.--",
      this.isConnected = false});
  @HiveField(0)
  String name;

  @HiveField(1)
  String ipAddress;

  @HiveField(2)
  String macAddress;

  @HiveField(3)
  bool isConnected;
}
