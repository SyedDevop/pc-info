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
  double volume;

  AudioState({
    required this.isMute,
    required this.volume,
  });

  factory AudioState.fromJson(Map<String, dynamic> json) => AudioState(
        isMute: json['isMute'],
        volume: json['volume']?.floorToDouble(),
      );
  @override
  String toString() {
    String muteStatus = 'isMute: $isMute';
    String volumeStatus = 'Volume: $volume';
    return '$muteStatus\n$volumeStatus\n';
  }
}
