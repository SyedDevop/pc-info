import 'package:flutter/material.dart';

import '/font/font_icon.dart';
import '/widget/utils/utils_cards.dart';

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
            icon: FFIcons.mubileAudio,
            footer: 'Audio',
          ),
          UtilCard(
            icon: FFIcons.process,
            footer: 'Processes',
          ),
          UtilCard(
            icon: FFIcons.bufferPool,
            footer: 'Performances',
          ),
          UtilCard(
            icon: Icons.spatial_audio,
            footer: 'Audio',
          ),
          UtilCard(
            icon: Icons.spatial_audio,
            footer: 'Audio',
          ),
        ],
      ),
    );
  }
}
