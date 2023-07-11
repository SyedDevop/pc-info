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
    return showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Text("Helll"),
          );
        });
  }
}
