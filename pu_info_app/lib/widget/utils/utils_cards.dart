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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              footer,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        ],
      ),
    );
  }
}
