import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pu_info_app/socket_server.dart';

import '/widget/server/server_bottom_sheet.dart';
import '/models/server_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Server> serverBox;
  @override
  void initState() {
    super.initState();
    serverBox = Hive.box("server");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pc Info")),
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: serverBox.listenable(),
            builder: (context, box, _) {
              if (box.values.isEmpty) {
                return const Center(
                  child: Text("No contacts"),
                );
              }
              return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (_, index) {
                    Server curServer = box.getAt(index)!;
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.monitor_heart_rounded,
                          size: 35.0,
                          color: curServer.isConnected
                              ? Colors.greenAccent
                              : Colors.grey[700],
                        ),
                        title: Text(curServer.name),
                        subtitle: Text(
                            "IP : ${curServer.ipAddress}\nMac : ${curServer.macAddress}"),
                        isThreeLine: true,
                        onTap: () {
                          SocketService.init(index);
                        },
                      ),
                    );
                  });
            }),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () => showServerBottomSheet(context),
          tooltip: "Add Server",
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}
