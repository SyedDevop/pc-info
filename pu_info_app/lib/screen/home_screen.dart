import 'package:flutter/material.dart';

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
    final _formKey = GlobalKey<FormState>();
    return showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 450.00,
            padding:
                const EdgeInsets.symmetric(vertical: 35.5, horizontal: 15.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.name,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "* Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "* Ip Address"),
                      validator: (val) {
                        RegExp valRe =
                            RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}:\d{4}$');
                        if (val != null && valRe.hasMatch(val)) {
                          return null;
                        }
                        return "Please enter valid Ip";
                      },
                    ),
                  ],
                )),
          );
        });
  }
}
