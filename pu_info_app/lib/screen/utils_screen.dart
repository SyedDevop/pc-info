import 'package:flutter/material.dart';
import 'package:pu_info_app/widget/utils/utils_cards.dart';

class UtilsScreen extends StatelessWidget {
  const UtilsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Utils')),
      body: GridView.count(
        crossAxisCount: 4,
        children: const [
          UtilCard(
            icon: Icon(Icons.spatial_audio),
            footer: 'Audio',
          ),
          UtilCard(
            icon: Icon(Icons.spatial_audio),
            footer: 'Processes',
          ),
          UtilCard(
            icon: Icon(Icons.spatial_audio),
            footer: 'Performances',
          ),
          UtilCard(
            icon: Icon(Icons.spatial_audio),
            footer: 'Audio',
          ),
          UtilCard(
            icon: Icon(Icons.spatial_audio),
            footer: 'Audio',
          ),
        ],
      ),
    );
  }
}
