import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/server_model.dart';
import 'router/router.dart';
import 'theme.dart';

// TODO: (2) Create the Form widget.
// TODO: (3) Use ShowBottomSheet for form in put of the server.
// * Separate the ui and logic widget form the ShowBottomSheet.
void main() async {
  // IO.Socket socket = IO.io(
  //   "http://localhost:3000",
  //   IO.OptionBuilder().setTransports(["websocket"]).build(),
  // );
  // socket.onConnect((_) {
  //   print("Connect");
  // });
  // socket.emitWithAck("isMute", "", ack: (e) => print(e));
  //

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ServerAdapter());
  var box = await Hive.openBox<Server>('server');
  box.values.forEach((e) => print(e.toString()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "pc info app",
      debugShowCheckedModeBanner: false,
      theme: MyTheme.light,
      darkTheme: MyTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
