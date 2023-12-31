import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pu_info_app/socket_server.dart';

import 'const.dart';
import 'models/server_model.dart';
import 'router/router.dart';
import 'theme.dart';

void main() async {
  // IO.Socket socket = SocketService(url: "http://192.168.1.106:3000").socket;
  // socket.onConnect((_) {
  //   print("Connect");
  // });
  // socket.emitWithAck("isMute", "", ack: (e) => print(e));
  //

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ServerAdapter());
  final prevBox = await Hive.openBox<int>(kPrevSess);
  final box = await Hive.openBox<Server>(kServer);
  SocketService(prevBox.get(kPrevSessKey));
  print(prevBox.values);
  for (var e in box.values) {
    print(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'pc info app',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
