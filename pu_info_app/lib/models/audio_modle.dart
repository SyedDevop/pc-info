class AudioProcess {
  int pid;
  String name;

  AudioProcess({required this.pid, required this.name});
  factory AudioProcess.fromJson(Map<String, dynamic> json) => AudioProcess(
        pid: json['pid'],
        name: json['name'],
      );
}

class AudioState {
  bool isMute;
  List<AudioProcess> audioProcess;
  double volume;

  AudioState({
    required this.isMute,
    required this.audioProcess,
    required this.volume,
  });

  factory AudioState.fromJson(Map<String, dynamic> json) => AudioState(
        isMute: json['isMute'],
        audioProcess: List<AudioProcess>.from(json['audioProcess'].map(
          (x) => AudioProcess.fromJson(x),
        )),
        volume: json['volume']?.floorToDouble(),
      );
  @override
  String toString() {
    String muteStatus = 'isMute: $isMute';
    String volumeStatus = 'Volume: $volume';
    String processStatus =
        'Audio Processes:\n${audioProcess.map((process) => '  - ${process.name} (pid: ${process.pid})').join('\n')}';
    return '$muteStatus\n$volumeStatus\n$processStatus';
  }
}
