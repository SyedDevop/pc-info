import 'package:flutter/material.dart';
import 'package:pu_info_app/models/audio_modle.dart';
import 'package:pu_info_app/widget/ui/audio_nob.dart';

import 'package:pu_info_app/socket_server.dart';
import 'package:socket_io_client/socket_io_client.dart';
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
        children: [
          Builder(builder: (context) {
            return UtilCard(
              icon: FFIcons.mubileAudio,
              footer: 'Audio',
              onPress: () => {showAudioBottomSheet(context)},
            );
          }),
          const UtilCard(
            icon: FFIcons.process,
            footer: 'Processes',
          ),
          const UtilCard(
            icon: FFIcons.bufferPool,
            footer: 'Performances',
          ),
          const UtilCard(
            icon: Icons.spatial_audio,
            footer: 'Audio',
          ),
          const UtilCard(
            icon: Icons.spatial_audio,
            footer: 'Audio',
          ),
        ],
      ),
    );
  }

  showAudioBottomSheet(BuildContext context) {
    return showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 15.0),
          child: const AudioControle(),
        );
      },
    );
  }
}

class AudioControle extends StatefulWidget {
  const AudioControle({super.key});

  @override
  State<AudioControle> createState() => _AudioControleState();
}

class _AudioControleState extends State<AudioControle> {
  late Socket socket;
  double? initValue;
  bool isMute = false;
  @override
  void initState() {
    super.initState();
    socket = SocketService.socket!;
    socket.emitWithAck('getAudioState', '', ack: (audioState) {
      final audio = AudioState.fromJson(audioState);
      setState(() {
        initValue = audio.volume;
        isMute = audio.isMute;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Mater Volume',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 15.0),
        AudioNob(
          initialValue: initValue,
          onChange: (value) => socket.emit('setVolume', value.floor()),
        ),
        OutlinedButton.icon(
          onPressed: () {
            final mute = !isMute;
            socket.emit('setMute', mute);
            setState(() {
              isMute = mute;
            });
          },
          label: Text(isMute ? 'Un Mute' : 'Mute'),
          icon: Icon(
              isMute ? Icons.volume_mute_rounded : Icons.volume_off_rounded),
        ),
      ],
    );
  }
}
