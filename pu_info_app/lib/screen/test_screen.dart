import 'package:flutter/material.dart';
import 'package:pu_info_app/widget/ui/audio_nob.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Screen')),
      body: const AudioNob(),
    );
  }
}
