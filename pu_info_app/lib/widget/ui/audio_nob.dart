import 'package:flutter/material.dart';
import 'package:pu_info_app/socket_server.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

List<Color> colors = const [
  Color(0xFF1EE196),
  Color(0xFF1E6AE1),
  Color(0xFF1ECBE1),
];

class AudioNob extends StatelessWidget {
  AudioNob({super.key, this.initialValue, this.onChange});
  final double? initialValue;
  final socket = SocketService.socket;
  final void Function(double)? onChange;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SleekCircularSlider(
      appearance: CircularSliderAppearance(
          customColors: CustomSliderColors(
            progressBarColors: colors,
          ),
          size: 250,
          infoProperties: InfoProperties(
            mainLabelStyle: const TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontWeight: FontWeight.w100),
            modifier: (double value) {
              final newNalue = value.floor();
              return '$newNalue %';
            },
          )),
      onChange: onChange,
      min: 0,
      max: 100,
      initialValue: initialValue ?? 10,
    ));
  }
}
