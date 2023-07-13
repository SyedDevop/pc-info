import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../models/server_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pc Info")),
      body: const Center(
        child: Text("hello"),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () => _showBottomSheet(context),
          tooltip: "Add Server",
          child: const Icon(Icons.add),
        );
      }),
    );
  }

  _showBottomSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCon = TextEditingController();
    final ipCon = TextEditingController();
    void handleSubmit(BuildContext context) {
      if (formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adding data to database'),
          ),
        );
        context.pop();
        var serverBox = Hive.box<Server>("server");
        Server newServer = Server(name: nameCon.text, ipAddress: ipCon.text);
        serverBox.add(newServer);
      }
    }

    return showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 400.00,
            padding:
                const EdgeInsets.symmetric(vertical: 60.0, horizontal: 15.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameCon,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: "* Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: ipCon,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration:
                        const InputDecoration(labelText: "* Ip Address"),
                    validator: (val) {
                      RegExp valRe =
                          RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}:\d{4}$');
                      if (val != null && valRe.hasMatch(val)) {
                        return null;
                      }
                      return "Please enter valid Ip";
                    },
                    onEditingComplete: () => handleSubmit(context),
                  ),
                  const SizedBox(height: 20.0),
                  OutlinedButton(
                    onPressed: () {
                      handleSubmit(context);
                    },
                    child: const Text("submit"),
                  )
                ],
              ),
            ),
          );
        });
  }
}
