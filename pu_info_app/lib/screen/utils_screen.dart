import 'package:flutter/material.dart';

class UtilsScreen extends StatelessWidget {
  const UtilsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Utils')),
      body: GridView.count(
        crossAxisCount: 4,
        children: const [
          Card(
            child: Text('Audio'),
          ),
          Card(
            child: Text('Audio'),
          ),
          Card(
            child: Text('Audio'),
          ),
          Card(
            child: Text('Audio'),
          ),
          Card(
            child: Text('Audio'),
          ),
          Card(
            child: Text('Audio'),
          ),
        ],
      ),
    );
  }
}
