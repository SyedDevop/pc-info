import 'package:flutter/material.dart';

class AudioNob extends StatelessWidget {
  const AudioNob({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: AudioNobPainter(),
          child: Container(),
        ),
      ],
    );
  }
}

class AudioNobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
