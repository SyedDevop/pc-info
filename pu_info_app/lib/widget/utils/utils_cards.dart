import 'package:flutter/material.dart';

class UtilCard extends StatelessWidget {
  const UtilCard({
    super.key,
    required this.icon,
    required this.footer,
  });

  final IconData icon;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Icon(
              icon,
              size: 40,
            ),
          ),
          Text(
            footer,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
