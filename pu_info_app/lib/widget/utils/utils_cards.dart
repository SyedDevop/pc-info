import 'package:flutter/material.dart';

class UtilCard extends StatelessWidget {
  const UtilCard({
    super.key,
    required this.icon,
    required this.footer,
  });

  final Icon icon;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          Expanded(
            child: Icon(
              Icons.spatial_audio,
              size: 40,
            ),
          ),
          Text(
            'Audio',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
