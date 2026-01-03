import 'dart:io';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> setPlaylist(List<String> paths) async {
    final sources = paths
        .where((path) => File(path).existsSync())
        .map((path) => AudioSource.file(path))
        .toList();

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
    );
  }

  Future<void> playAt(int index) async {
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  Future<void> play(String path) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception('Arquivo não encontrado');
    }

    await _player.setFilePath(path);
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  /// 🔑 AQUI ESTÁ A CORREÇÃO
  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }

Stream<Duration> get positionStream => _player.positionStream;
Stream<Duration?> get durationStream => _player.durationStream;
Stream<PlayerState> get playerStateStream => _player.playerStateStream;

bool get isPlaying => _player.playing;
int? get currentIndex => _player.currentIndex;

}
