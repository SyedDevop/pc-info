import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '/models/server_model.dart';

showServerBottomSheet(BuildContext context) {
  return showBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 400.00,
        padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 15.0),
        child: AddServerForm(),
      );
    },
  );
}

class AddServerForm extends StatelessWidget {
  AddServerForm({
    super.key,
  });
  final formKey = GlobalKey<FormState>();
  final nameCon = TextEditingController();
  final ipCon = TextEditingController();

  void _handleSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adding data to database'),
        ),
      );
      context.pop();
      var serverBox = Hive.box<Server>('server');
      Server newServer = Server(name: nameCon.text, ipAddress: ipCon.text);
      serverBox.add(newServer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
            decoration: const InputDecoration(labelText: '* Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
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
            decoration: const InputDecoration(
              labelText: '* Ip Address',
              hintText: '192.168.0.1:3000',
            ),
            validator: (val) {
              RegExp valRe = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}:\d{4}$');
              if (val != null && valRe.hasMatch(val)) {
                return null;
              }
              return 'Please enter valid Ip';
            },
            onEditingComplete: () => _handleSubmit(context),
          ),
          const SizedBox(height: 20.0),
          OutlinedButton(
            onPressed: () {
              _handleSubmit(context);
            },
            child: const Text('submit'),
          )
        ],
      ),
    );
  }
}
